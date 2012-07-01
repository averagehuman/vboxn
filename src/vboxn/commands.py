
import os
import sys

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

class Destroy(VBoxManageCommandBase):
    """Unregister a VirtualBox machine and delete all attached disks.

    More info here
    """

    @assert_vm_exists
    def take_action(self, *parsed_args):
        client.destroy_vm(self.vm_name)

class List(Command):
    """List VirtualBox objects - vms, adapters, hard drives etc.

    """

    def get_parser(self, prog_name):
        parser = super(List, self).get_parser(prog_name)
        parser.add_argument(
            'objtype',
            choices=[
                'vms', 'runningvms', 'ostypes', 'hdds', 'dvds'
            ],
            help=" an object type, eg. vms",
        )
        return parser

    def take_action(self, *parsed_args):
        for line in client.list_objects(parsed_args[0].objtype):
            sys.stdout.write(line+'\n')

