# load the pypes framework
import zmq
import errno
from pkg_resources import require
require('pypes')

import logging
import logging.config
from r_distribution.logger_config import config_dictionary
from r_distribution.basic_parser import BasicParser
log = logging.getLogger()

# import the Dataflow module
from pypes.pipeline import Dataflow
# import the Component Interface
from pypes.component import Component
# import the built-in ConsoleOutputWriter
from pypes.filters import ConsoleOutputWriter
from pypes.plugins.nm_function import NMFunction
import pypes.packet

import pprint


class ZMQReplier(Component):
    __metatype__ = 'PUBLISHER'

    def __init__(self):
        Component.__init__(self)
        self.set_parameter("port", 40000)

    def run(self):
        port = self.get_parameter("port")
        context = zmq.Context()
        socket = context.socket(zmq.REP)
        socket.bind("tcp://*:{0}".format(port))
        while True:
            for packet in self.receive_all('in'):
                data = packet.get("data")
                # if requested through the socket, I will send the data
                message = socket.recv_string()
                socket.send_pyobj(data)
            self.yield_ctrl()


class Printer(Component):
    __metatype__ = 'PUBLISHER'

    def __init__(self):
        Component.__init__(self)

    def run(self):
        while True:
            for packet in self.receive_all('in'):
                print(packet.get("data"))
            self.yield_ctrl()


class HelloWorld(Component):
    __metatype__ = 'ADAPTER'

    def __init__(self):
        Component.__init__(self)

    def run(self):
        while True:
            for packet in self.receive_all('in'):
                message = 'Hello {0}'.format(packet.get("data"))
                packet.set("data", message)
                self.send('out', packet)
            self.yield_ctrl()


def basic_network_factory():
    hello = HelloWorld()          # our custom component
    printer = Printer()  # writes to STDOUT
    network = {
        hello: {printer: ('out', 'in')}
    }
    return network


def add_printer(network):
    """add an output to all components in a network

    :network: @todo
    :returns: @todo

    """
    printing_network = {}
    port = 40000
    for component, children in network.items():
        printing_network[component] = {}
        for child, ports in children.items():
            splitter = NMFunction(m=2)
            publisher = ZMQReplier()
            publisher.set_parameter("port", port)
            printing_network[component].update({
                splitter: (ports[0], "in")
            })
            printing_network[splitter] = {
                publisher: ("out1", "in"),
                child: ("out", ports[1])
            }
            port += 1
    return printing_network


def include_network(config):
    """add random object to config

    :config: @todo
    :returns: @todo

    """
    zmq_context = zmq.Context()
    config.registry.zmq_context = zmq_context
    network = basic_network_factory()
    config.registry.zmq_receiver = zmq_context.socket(zmq.REQ)
    config.registry.zmq_receiver.connect("tcp://127.0.0.1:40000")
    config.registry.pipeline = Dataflow(add_printer(network))


if __name__ == '__main__':
    config_dictionary['handlers']['default']['level'] = 'DEBUG'
    config_dictionary['loggers']['']['level'] = 'DEBUG'
    logging.config.dictConfig(config_dictionary)
    # create a new data flow
    network = basic_network_factory()
    p = Dataflow(add_printer(network))
    #send some data through the data flow
    for name in ['Tom', 'Dick', 'Harry']:
        packet = pypes.packet.Packet()
        packet.set("data", name)
        p.send(packet)
    # shut down the data flow
    p.close()
