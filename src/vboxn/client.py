
import os
import subprocess

CalledProcessError = subprocess.CalledProcessError

try:
    # new in python 2.7
    call = subprocess.check_output
except AttributeError:

    def call(*popenargs, **kwargs):
        r"""Run command with arguments and return its output as a byte string.

        If the exit code was non-zero it raises a CalledProcessError.  The
        CalledProcessError object will have the return code in the returncode
        attribute and output in the output attribute.

        The arguments are the same as for the Popen constructor.  Example:

        >>> check_output(["ls", "-l", "/dev/null"])
        'crw-rw-rw- 1 root root 1, 3 Oct 18  2007 /dev/null\n'

        The stdout argument is not allowed as it is used internally.
        To capture standard error in the result, use stderr=STDOUT.

        >>> check_output(["/bin/sh", "-c",
        ...               "ls -l non_existent_file ; exit 0"],
        ...              stderr=STDOUT)
        'ls: non_existent_file: No such file or directory\n'
        """
        if 'stdout' in kwargs:
            raise ValueError('stdout argument not allowed, it will be overridden.')
        process = subprocess.Popen(stdout=subprocess.PIPE, *popenargs, **kwargs)
        output, unused_err = process.communicate()
        retcode = process.poll()
        if retcode:
            cmd = kwargs.get("args")
            if cmd is None:
                cmd = popenargs[0]
            raise subprocess.CalledProcessError(retcode, cmd, output=output)
        return output

def get_multiple_info(vm, key):
    key = key + ':'
    for line in call(['VBoxManage', 'showvminfo', vm]).splitlines():
        if line.startswith(key):
            yield line[len(key):].strip()

def get_info(vm, key):
    for result in get_multiple_info(vm, key):
        return result

def list_vms():
    lines = call([
        'VBoxManage', 'list', 'vms',
    ]) or ''
    return [line.split()[0][1:-1] for line in lines.splitlines() if line]

def list_objects(objtype):
    lines = call([
        'VBoxManage', 'list', objtype,
    ]) or ''
    return lines.splitlines()

def start_vm(name):
    return call([
        'VBoxManage', 'startvm', name,
    ])

def start_headless_vm(name, vrde='config'):
    return os.system(' '.join([
        'VBoxHeadless', '--startvm', name, '--vrde=%s' % vrde, '&',
    ]))

def poweroff_vm(name):
    return call([
        'VBoxManage', 'controlvm', name, 'poweroff',
    ])

def destroy_vm(name):
    return call([
        'VBoxManage', 'unregistervm', name, '--delete',
    ])

def modify_vm(name, argv):
    args = ['VBoxManage', 'modifyvm', name] + argv
    return call(args)

def show_vm_info(name):
    lines = call([
        'VBoxManage', 'showvminfo', name
    ]) or ''
    return lines.splitlines()

def clone_vm(name, clone_name, adapter=None):
    yield call([
        'VBoxManage', 'clonevm', name
    ])

