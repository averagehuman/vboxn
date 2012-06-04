
class UIError(Exception):
    pass

class VMDoesNotExist(UIError):

    def __init__(self, vm_name):
        self.msg = "virtual machine '%s' does not exist" % vm_name

    def __str__(self):
        return self.msg

