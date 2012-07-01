
import logging
import sys
import inspect

from cliff.app import App
from cliff.command import Command
from cliff.commandmanager import CommandManager, EntryPointWrapper

from vboxn.utils import import_object

def iscommandclass(obj):
    return obj is not Command \
            and inspect.isclass(obj) \
            and hasattr(obj, '__dict__') \
            and 'take_action' in obj.__dict__

def commands_from_module(m):
    if isinstance(m, basestring):
        m = import_object(m)
    d = {}
    for k, v in m.__dict__.items():
        if iscommandclass(v):
            d[k.lower()] = EntryPointWrapper(k.lower(), v)
    return d

class UICommandManager(CommandManager):

    def _load_commands(self):
        d = commands_from_module('vboxn.commands')
        self.commands.update(d)

class UI(App):

    log = logging.getLogger(__name__)

    def __init__(self):
        super(UI, self).__init__(
            description='Command line interaction with VirtualBox machine images.',
            version='0.1',
            command_manager=UICommandManager('vboxn.ui'),
            )

    def interact(self):
        return self.run(['-h'])

def main(argv=sys.argv[1:]):
    ui = UI()
    return ui.run(argv)


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))

