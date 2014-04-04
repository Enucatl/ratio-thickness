"""Calculate average df, abs, ratio values for each line."""

import numpy as np
import zmq

import logging
import logging.config
from r_distribution.logger_config import config_dictionary
log = logging.getLogger()

import pypes.pipeline
import pypes.packet
import pypes.component
from pypes.component import HigherOrderComponent

from pypes.plugins.hdf5 import Hdf5ReadDataset
from pypes.plugins.zmq import ZmqPush
from pypes.plugins.nm_function import NMFunction
from r_distribution.feature_segmentation import MinimumThresholdSegmentation


def multiple_outputs_reader(m=2):
    "repeat the output of the reader m times"
    reader = Hdf5ReadDataset()
    reader.__metatype__ = "TRANSFORMER"
    out = NMFunction(n=1, m=m)
    network = {
        reader: {
            out: ("out", "in")
        }
    }
    return network


def average_function(a, w):
    "average over last axis"
    return (np.average(a, axis=-1, weights=w),)


def average():
    "calculate weighted average"
    average = NMFunction(n=2)
    average.set_parameter(
        "function", average_function)
    return average


def datasets(*_):
    "return the name of the datasets"
    return ("postprocessing/absorption",
            "postprocessing/visibility_reduction")


def log_function(df, a):
    "logarithm ratio"
    return (np.log(a)/np.log(df),)


def ratio_thickness_network():
    in1out2 = NMFunction(n=1, m=2)
    in1out2.__metatype__ = "ADAPTER"
    in1out2.set_parameter("function", datasets)
    abs_reader = HigherOrderComponent(multiple_outputs_reader(m=4))
    df_reader = HigherOrderComponent(multiple_outputs_reader(m=3))
    feature_segmentation = MinimumThresholdSegmentation()
    feature_segmentation_out = NMFunction(m=4)
    reader_outputs = NMFunction(n=3)
    reader_outputs.set_parameter(
        "function",
        lambda *args: (np.dstack(args).tolist(),))
    reader_replier = ZmqPush(port=40000)
    log_ratio = NMFunction(n=2)
    log_ratio.set_parameter(
        "function",
        log_function)
    average_abs = average()
    average_df = average()
    average_r = average()
    average_outputs = NMFunction(n=3)
    average_replier = ZmqPush(port=40001)
    average_outputs.set_parameter(
        "function",
        lambda *args: (np.vstack(args).T.tolist(),))
    network = {
        in1out2: {
            abs_reader: ("out", "in"),
            df_reader: ("out1", "in"),
        },
        abs_reader: {
            average_abs: ("out", "in"),
            feature_segmentation: ("out1", "in"),
            log_ratio: ("out2", "in1"),
            reader_outputs: ("out3", "in"),
        },
        df_reader: {
            log_ratio: ("out", "in"),
            average_df: ("out1", "in"),
            reader_outputs: ("out2", "in1"),
        },
        feature_segmentation: {
            feature_segmentation_out: ("out", "in"),
        },
        log_ratio: {
            average_r: ("out", "in"),
        },
        feature_segmentation_out: {
            average_abs: ("out", "in1"),
            average_df: ("out1", "in1"),
            average_r: ("out2", "in1"),
            reader_outputs: ("out3", "in2"),
        },
        average_abs: {
            average_outputs: ("out", "in"),
        },
        average_df: {
            average_outputs: ("out", "in1"),
        },
        average_r: {
            average_outputs: ("out", "in2"),
        },
        average_outputs: {
            average_replier: ("out", "in"),
        },
        reader_outputs: {
            reader_replier: ("out", "in"),
        },
    }
    return network


def include_pipeline(config):
    network = ratio_thickness_network()
    config.registry.pipeline = pypes.pipeline.Dataflow(network, n=4)


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(__doc__)
    parser.add_argument(
        "file", nargs="?",
        default="static/data/S00918_S00957.hdf5")
    args = parser.parse_args()
    config_dictionary['handlers']['default']['level'] = 'DEBUG'
    config_dictionary['loggers']['']['level'] = 'DEBUG'
    logging.config.dictConfig(config_dictionary)
    pipeline = pypes.pipeline.Dataflow(ratio_thickness_network(), n=3)
    packet = pypes.packet.Packet()
    packet.set("file_name", args.file)
    context = zmq.Context()
    sockets = []
    for i in range(40000, 40002):
        socket = context.socket(zmq.PULL)
        socket.connect("tcp://127.0.0.1:{0}".format(i))
        sockets.append(socket)
    pipeline.send(packet)
    for socket in sockets:
        print("socket receiving")
        socket.recv_json()
    pipeline.close()
