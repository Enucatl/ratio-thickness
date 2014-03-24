# load the pypes framework
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
    printer = ConsoleOutputWriter()  # writes to console (STDOUT)
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
    for component, children in network.items():
        printing_network[component] = {}
        for child, ports in children.items():
            splitter = NMFunction(m=2)
            publisher = Printer()
            printing_network[component].update({
                splitter: (ports[0], "in")
            })
            printing_network[splitter] = {
                publisher: ("out1", "in"),
                child: ("out", ports[1])
            }
    return printing_network


def include_network(config):
    """add random object to config

    :config: @todo
    :returns: @todo

    """
    network = basic_network_factory()
    config.registry.pipeline = Dataflow(add_printer(network))


if __name__ == '__main__':
    config_dictionary['handlers']['default']['level'] = 'DEBUG'
    config_dictionary['loggers']['']['level'] = 'DEBUG'
    logging.config.dictConfig(config_dictionary)
    # create a new data flow
    network = basic_network_factory()
    pprint.pprint(network)
    #p = Dataflow(network)
    pprint.pprint(add_printer(network))
    p = Dataflow(add_printer(network))
    #send some data through the data flow
    for name in ['Tom', 'Dick', 'Harry']:
        packet = pypes.packet.Packet()
        packet.set("data", name)
        p.send(packet)
    # shut down the data flow
    p.close()
