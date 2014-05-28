from pyramid.view import view_config
import pypes.packet
import zmq
import h5py
import numpy as np
import json


@view_config(route_name='datasets', renderer='json')
def get_datasets(request):
    datasets = [
        {
            "name": "Sugar",
            "file": "ratio_thickness/static/data/S00001_S00100.hdf5",
            "a (mm)": 121,
            "b (mm)": 14,
            "simulated": False,
            "scattering": "high",
        },
        {
            "name": "Salt",
            "file": "ratio_thickness/static/data/S00101_S00200.hdf5",
            "a (mm)": 121,
            "b (mm)": 14,
            "simulated": False,
            "scattering": "high",
        },
        {
            "name": "Coffee",
            "file": "ratio_thickness/static/data/S00201_S00300.hdf5",
            "a (mm)": 121,
            "b (mm)": 14,
            "simulated": False,
            "scattering": "high",
        },
        {
            "name": "Teflon",
            "file": "ratio_thickness/static/data/S00501_S00600.hdf5",
            "a (mm)": 50,
            "b (mm)": 6.3,
            "simulated": False,
            "scattering": "low",
        },
        {
            "name": "Nylon",
            "file": "ratio_thickness/static/data/S00401_S00500.hdf5",
            "a (mm)": 50,
            "b (mm)": 9.40,
            "simulated": False,
            "scattering": "low",
        },
        {
            "name": "Paper",
            "file": "ratio_thickness/static/data/S00301_S00400.hdf5",
            "a (mm)": 96,
            "b (mm)": 37,
            "simulated": False,
        },
    ]
    return datasets


@view_config(route_name='normalizedchisquare', renderer='json')
def get_normalized_chi_square(request):
    json = request.json_body
    file_name = json["file"]
    hdf5_file = h5py.File(file_name, "r")
    try:
        fitted = hdf5_file["postprocessing/dpc_reconstruction"]
        flat_parameters = hdf5_file["postprocessing/flat_parameters"]
        points = hdf5_file["postprocessing/phase_stepping_curves"]
        fitted = np.rollaxis(fitted[0, 300:850, ...], 1)
        points = np.rollaxis(points[0, 300:850, ...], 1)
        n = points.shape[-1]
        flat_parameters = np.rollaxis(flat_parameters[0, 300:850, ...], 1)
        flat_parameters[..., 2] *= 2
        fitted[..., 2] *= flat_parameters[..., 2] / fitted[..., 0]
        fitted[..., 1] += flat_parameters[..., 1]
        fitted[..., 0] *= flat_parameters[..., 0]
        dataset = np.tile(
            np.arange(n),
            (
                points.shape[0],
                points.shape[1],
                1
            ))
        dataset = 2 * np.pi * dataset / (n + 1) + fitted[..., 1, np.newaxis]
        dataset = (fitted[..., 0, np.newaxis] +
                   fitted[..., 2, np.newaxis] * np.cos(dataset)) / n
        dataset = np.sum((dataset - points) ** 2 / points, axis=-1) / n
        print(dataset.shape)
        dataset = dataset.tolist()
    except KeyError:
        dataset = {
            "error": "dataset not found!"
        }
    finally:
        hdf5_file.close()
    return dataset


@view_config(route_name='hdf5dataset', renderer='json')
def get_hdf5_dataset(request):
    json = request.json_body
    file_name = json["file"]
    dataset_name = json["dataset"]
    hdf5_file = h5py.File(file_name, "r")
    try:
        dataset = hdf5_file[dataset_name]
        dataset = np.rollaxis(
            dataset[0, 300:850, ...], 1)
        dataset = dataset.tolist()
    except KeyError:
        dataset = {
            "error": "dataset {0} not found!".format(
                dataset_name),
        }
    finally:
        hdf5_file.close()
    return dataset


@view_config(route_name='pipeline', renderer='json')
def start_pipeline(request):
    json = request.json_body
    packet = pypes.packet.Packet()
    packet.set("file_name", json["filename"])
    request.registry.pipeline.send(packet)
    return "pipeline started with {0[filename]}".format(json)


@view_config(route_name='pipelineoutput', renderer='json')
def get_output(request):
    port = request.matchdict["port"]
    context = zmq.Context()
    socket = context.socket(zmq.PULL)
    socket.connect("tcp://127.0.0.1:{0}".format(port))
    array = socket.recv_json()
    socket.close()
    return array


@view_config(route_name='aggregatedoutput', renderer='json')
def get_aggregated_output(request):
    averages = []
    context = zmq.Context()
    unused_port = 40000
    port = 40001
    unused_socket = context.socket(zmq.PULL)
    socket = context.socket(zmq.PULL)
    unused_socket.connect("tcp://127.0.0.1:{0}".format(unused_port))
    socket.connect("tcp://127.0.0.1:{0}".format(port))
    for dataset in request.json_body:
        packet = pypes.packet.Packet()
        packet.set("file_name", dataset["file"])
        request.registry.pipeline.send(packet)
        unused_socket.recv_json()
        array = socket.recv_json()
        averages.append({
            "name": dataset["name"],
            "simulated": dataset["simulated"],
            "values": array
        })
    unused_socket.close()
    socket.close()
    with open("aggregated.json", "w") as json_output:
        json.dump(averages, json_output)
    return averages


@view_config(route_name='phase_stepping',
             renderer='templates/phase_stepping.mako')
def get_phase_stepping(request):
    return {"title": "Phase Stepping"}


@view_config(route_name='home', renderer='templates/index.mako')
def get_home(request):
    return {"title": "Home"}


@view_config(route_name='single_dataset',
             renderer='templates/single_dataset.mako')
def get_reconstruction(request):
    return {"title": "Single dataset analysis"}


@view_config(route_name='aggregated', renderer='templates/aggregated.mako')
def get_segmentation(request):
    return {"title": "Aggregated results"}
