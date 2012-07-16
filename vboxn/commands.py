
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

class Start(VBoxManageCommandBase):
    """Start (power up) an existing VM with GUI frontend"""
    @assert_vm_exists
    def take_action(self, *parsed_args):
        client.start_vm(self.vm_name)

class Headless(VBoxManageCommandBase):
    """Start (power up) an existing VM with no frontend"""

    def get_parser(self, prog_name):
        parser = super(Headless, self).get_parser(prog_name)
        parser.add_argument('--vrde', action='store_true', help="enable remote desktop server")
        return parser

    @assert_vm_exists
    def take_action(self, *parsed_args):
        if parsed_args[0].vrde:
            # enable if the machine has the vrde setting selected
            vrde='config'
        else:
            # else, default is off
            vrde='off'
        client.start_headless_vm(self.vm_name, vrde)

class Stop(VBoxManageCommandBase):
    """Stop a running VM"""
    @assert_vm_exists
    def take_action(self, *parsed_args):
        client.poweroff_vm(self.vm_name)

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

class Info(VBoxManageCommandBase):
    """Show all VM info

    """

    @assert_vm_exists
    def take_action(self, *parsed_args):
        for line in client.show_vm_info(self.vm_name):
            sys.stdout.write(line+'\n')

