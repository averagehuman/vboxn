
import os

from cliff.command import Command

from . import client
from . import errors

class VBoxManageCommandBase(Command):

    def get_parser(self, prog_name):
        parser = super(VBoxManageCommandBase, self).get_parser(prog_name)
        parser.add_argument('vm_name', help="a virtual machine name")
        return parser

def assert_vm_exists(method):
    def run(self, *parsed_args):
        name = parsed_args[0].vm_name
        if name not in client.list_vms():
            raise errors.VMDoesNotExist(name)
        self.vm_name = name
        return method(self, *parsed_args)
    return run

class hello(Command):
    """Hi there

    More info here
    """

    def run(self, *parsed_args):
        os.system('vboxen-init')

class destroy(VBoxManageCommandBase):
    """Unregister a VirtualBox machine and delete all attached disks.

    More info here
    """

    @assert_vm_exists
    def run(self, *parsed_args):
        client.destroy_vm(self.vm_name)

