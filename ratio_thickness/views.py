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
            "name": "Teflon",
            "file": "ratio_thickness/static/data/S00208_S00307.hdf5",
            "a (mm)": 50,
            "b (mm)": 6.3,
            "simulated": False,
        },
        {
            "name": "Nylon",
            "file": "ratio_thickness/static/data/S00108_S00207.hdf5",
            "a (mm)": 50,
            "b (mm)": 9.40,
            "simulated": False,
        },
        {
            "name": "Aluminium",
            "file": "ratio_thickness/static/data/S00718_S00757.hdf5",
            "a (mm)": 30.50,
            "b (mm)": 1,
            "simulated": False,
        },
        {
            "name": "Polystyrene",
            "file": "ratio_thickness/static/data/S00758_S00797.hdf5",
            "a (mm)": 62,
            "b (mm)": 20,
            "simulated": False,
        },
        {
            "name": "Carbon fibers",
            "file": "ratio_thickness/static/data/S00918_S00957.hdf5",
            "a (mm)": 49.35,
            "b (mm)": 4.1,
            "simulated": False,
        },
        {
            "name": "Copper",
            "file": "ratio_thickness/static/data/S00315_S00414.hdf5",
            "a (mm)": 30.50,
            "b (mm)": 1,
            "simulated": False,
        },
        {
            "name": "Paper",
            "file": "ratio_thickness/static/data/S00415_S00514.hdf5",
            "a (mm)": 96,
            "b (mm)": 37,
            "simulated": False,
        },
        {
            "name": "Sim. Ag",
            "file": "ratio_thickness/static/sim_data/Ag.hdf5",
            "b (mm)": 0.1,
            "a (mm)": 100,
            "simulated": True,
        },
        {
            "name": "Sim. Al",
            "file": "ratio_thickness/static/sim_data/Al.hdf5",
            "b (mm)": 0.1,
            "a (mm)": 100,
            "simulated": True,
        },
        {
            "name": "Sim. Au",
            "file": "ratio_thickness/static/sim_data/Au.hdf5",
            "b (mm)": 0.1,
            "a (mm)": 100,
            "simulated": True,
        },
        {
            "name": "Sim. C",
            "file": "ratio_thickness/static/sim_data/C.hdf5",
            "b (mm)": 0.1,
            "a (mm)": 100,
            "simulated": True,
        },
        {
            "name": "Sim. Cu",
            "file": "ratio_thickness/static/sim_data/Cu.hdf5",
            "b (mm)": 0.1,
            "a (mm)": 100,
            "simulated": True,
        },
        {
            "name": "Sim. Fe",
            "file": "ratio_thickness/static/sim_data/Fe.hdf5",
            "b (mm)": 0.1,
            "a (mm)": 100,
            "simulated": True,
        },
        {
            "name": "Sim. Si",
            "file": "ratio_thickness/static/sim_data/Si.hdf5",
            "b (mm)": 0.1,
            "a (mm)": 100,
            "simulated": True,
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
        dataset = np.tile(np.arange(n),
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
