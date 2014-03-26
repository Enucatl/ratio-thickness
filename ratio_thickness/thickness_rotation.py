"""Calculate average df, abs, ratio values for each line."""

import numpy as np

import logging
import logging.config
from r_distribution.logger_config import config_dictionary
from r_distribution.basic_parser import BasicParser
log = logging.getLogger()

import pypes.pipeline
import pypes.packet
import pypes.component
from pypes.component import HigherOrderComponent

from pypes.plugins.hdf5 import Hdf5Reader
from pypes.plugins.zmq import ZmqReplier
from pypes.plugins.nm_function import NMFunction
from r_distribution.feature_segmentation import ThicknessFeatureSegmentation


def multiple_outputs_reader(m=2):
    "repeat the output of the reader m times"
    reader = Hdf5Reader()
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
    return np.average(a, axis=-1, weights=w)


def average():
    "calculate weighted average"
    average = NMFunction(n=2)
    average.set_parameter(
        "function", average_function)
    return average


def datasets(*_):
    "return the name of the datasets"
    return [
        "postprocessing/absorption",
        "postprocessing/visibility_reduction"]


def log_function(df, a):
    "logarithm ratio"
    return np.log(df)/np.log(a)


def ratio_thickness_network():
    in1out2 = NMFunction(n=1, m=2)
    in1out2.__metatype__ = "ADAPTER"
    in1out2.set_parameter("function", datasets)
    abs_reader = HigherOrderComponent(multiple_outputs_reader(m=4))
    abs_reader_replier = ZmqReplier(port=40000)
    df_reader = HigherOrderComponent(multiple_outputs_reader(m=3))
    df_reader_replier = ZmqReplier(port=40001)
    feature_segmentation = ThicknessFeatureSegmentation()
    feature_segmentation_out = NMFunction(m=4)
    feature_segmentation_replier = ZmqReplier(port=40002)
    log_ratio = NMFunction(n=2, m=2)
    log_ratio.set_parameter(
        "function",
        log_function)
    log_ratio_replier = ZmqReplier(port=40003)
    average_abs = average()
    average_abs_replier = ZmqReplier(port=40004)
    average_df = average()
    average_df_replier = ZmqReplier(port=40005)
    average_r = average()
    average_r_replier = ZmqReplier(port=40006)
    network = {
        in1out2: {
            abs_reader: ("out", "in"),
            df_reader: ("out1", "in"),
        },
        abs_reader: {
            average_abs: ("out", "in"),
            feature_segmentation: ("out1", "in"),
            log_ratio: ("out2", "in1")
            abs_reader_replier: ("out3", "in")
        },
        df_reader: {
            log_ratio: ("out", "in"),
            average_df: ("out1", "in")
            df_reader_replier: ("out2", "in")
        },
        feature_segmentation: {
            feature_segmentation_out: ("out", "in")
        },
        log_ratio: {
            average_r: ("out", "in")
        },
        feature_segmentation_out: {
            average_abs: ("out", "in1"),
            average_df: ("out1", "in1"),
            average_r: ("out2", "in1")
            feature_segmentation_replier: ("out3", "in1")
        },
        average_abs: {
            average_abs_replier: ("out", "in")
        },
        average_df: {
            average_df_replier: ("out", "in")
        },
        average_r: {
            average_r_replier: ("out", "in")
        },
    }
    return network


def include_pipeline(config):
    config.registry.zmq_context = zmq.Context()
    config.registry.sockets = {}
    network = ratio_thickness_network()
    for port in range(40000, 40007):
        socket = config.registry.zmq_context.sockets(zmq.REQ)
        socket.connect("tcp://127.0.0.1:{0}".format(port))
        config.registry.sockets[port] = socket
    config.registry.pipeline = pypes.pipeline.Dataflow(network, n=4)
