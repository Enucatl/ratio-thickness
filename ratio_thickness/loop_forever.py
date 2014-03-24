import stackless
import time


def forever():
    count = 0
    while True:
        count += 1
        time.sleep(1)
        print(count)
        stackless.schedule()


def include_forever(config):
    config.registry.forever = forever
