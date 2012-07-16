
vboxn
######

`vboxn`_ automates the creation of VirtualBox machines.

Overiew
=======

`vboxn`_ is a Python/Bash library for creating new VirtualBox machine images
in a repeatable and unattended fashion. It is intended as a developer utility
similar in scope to `veewee`_, (from which it borrows a few deploy templates).

The package includes three user-facing scripts:

+ **vboxn-init** for creating and bootstrapping a new virtual machine (Bash).
+ **vboxn-postinstall** for further provisioning of the machine via default or
  user-supplied scripts (Bash).
+ **vboxn** for manipulating existing machines (Python).

Vagrant
-------

The default postinstall scripts are intended to configure the virtual machine
in a way that is compatible with `Vagrant`_. Once the postinstall step has
completed (and the machine has been shutdown), you ought to be able to
immediately package the vm as a `Vagrant`_ base box - for example, if the vm
you created is called **pangolin32** ::

    vagrant package --base pangolin32 --output pangolin32.box

The new box can then be further configured and added to an existing `Vagrant`_
installation as follows::

    vagrant box add pangolin32.box

See the `docs on Vagrant base boxes`_ for more info.

Status
======

The Ubuntu 12.04 guest install works, the archlinux guest install is not
complete - the default postinstall script fails after a certain point.
Since Ubuntu is all I need at the moment, there are no immediate plans to
go beyond that.

Installation
============

Install from `pypi`_::

    pip install vboxn

Development
-----------

Either::

    pip install -e git+https://github.com/devopsni/vboxn.git#egg=vboxn

Or::

    python bootstrap.py && ./bin/buildout

Quickstart
==========

The following will create and start a new VirtualBox machine in GUI mode,
and install Ubuntu 12.04 as the guest OS::

    vboxn-init pangolin32 ubuntu auto

If all went well and the OS was successfully installed, shutdown the virtual
machine (either from the GUI, or with ``sudo shutdown -h now``), and run the
postinstall script.::

    vboxn-postinstall pangolin32

If that succeeded, shutdown the machine again and launch it in headless
(GUI-less) mode::

    vboxn headless pangolin32

Now, wait enough time for the machine to boot and, assuming that you had a
public RSA key in the usual place (~/.ssh/id_rsa.pub) and it was copied to
the new machine successfully, you should be able to **ssh** to the running
instance (by default on address 192.168.44.100 via the hostonly adapter with
address 192.168.44.1).

The root password is set to **vboxn** and there is an admin user called
**vboxn** also with this password.

Both the init and postinstall phases will lauch "one-shot" web servers on
the host using the `netcat`_ utility, if the installation fails then these
may still be running and should be killed.

vboxn-init
===========

**vboxn-init** is a Bash script which will be installed as part of the standard
Python package installation, but could also be used standalone without
requiring either Python or `vboxn`_ itself.

Usage
-----

::

    vboxn-init <vm_name> <os_type> <auto|auto64|iso_source_file> [properties_file] [vm_option=..., vm_option=...]

    Description:

        Automate the creation of VirtualBox machine instances.

    Examples:

        vboxn-init testbox0 ubuntu auto
        vboxn-init testbox0 ubuntu auto kickstart=no
        vboxn-init testbox0 ubuntu auto kickstart_file=bootstrap.sh
        vboxn-init testbox0 ubuntu auto postinstall=no
        vboxn-init testbox0 ubuntu auto vm_basefolder=/srv/vbox
        vboxn-init testbox0 archlinux archlinux-2011.08.19-core-i686.iso
        vboxn-init testbox0 archlinux iso/archlinux-2011.08.19-core-i686.iso conf/vm.properties

    Notes:

      - Specifying 'auto' or 'auto64' for the iso source will download
        the latest generic 32/64-bit installation image for the OS

      - A properties file can optionally be used to supply overrides to the
        default VM config options, it is sourced by vboxn-init and should be a
        valid shell script.

      - Properties can additionally be defined as command line
        arguments. If both a properties file and command line properties
        are given, then those specified on the command line will take
        precedence.

      - If 'kickstart=yes' (the default) and 'kickstart_file' is
        unspecified, then a generic kickstart file will be downloaded
        from this project's github repository and run on the new guest
        machine. Similarly for 'postinstall=yes' and 'postinstall_configure_files'.

      - 'postinstall_configure_files' should be a space delimited list
        of files which will be concatenated in the order given and run
        on the guest after the OS is installed.  'postinstall_configure_root'
        can optionally be defined as a prefix for the postinstall files.

      - The kickstart and postinstall files are made available to the
        guest machine by running a "one shot" web server on the host.
        The default address for this web server to listen on is the inet
        IP address of the host, and the default port is 8585. This can be
        changed by specifying the 'kickstart_listen_on' parameter:

            vboxn-init testbox0 ubuntu auto kickstart_listen_on=192.168.1.101:8080



.. _vboxn: https://github.com/devopsni/vboxn
.. _veewee: https://github.com/jedi4ever/veewee
.. _netcat: http://en.wikipedia.org/wiki/Netcat
.. _vagrant: http://vagrantup.com
.. _docs on Vagrant base boxes: http://vagrantup.com/v1/docs/base_boxes.html
.. _pypi: http://pypi.python.org/pypi



