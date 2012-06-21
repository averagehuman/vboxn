
vboxn
######

`vboxn`_ automates the creation of VirtualBox machines.

Overiew
=======

`vboxn`_ is a Python/Bash library for headlessly creating new VirtualBox machine
images.  It is intended as a developer utility similar in scope to `veewee`_.

The package includes two user-facing scripts:

+ **vboxn-init** for creating and bootstrapping a new virtual machine
+ **vboxn** for manipulating existing machines.

Installation
============

Install the development version with pip::

    pip install -e git+https://github.com/devopsni/vboxn.git#egg=vboxn


vboxn-init
===========

**vboxn-init** is a Bash script and, although it will be installed as part
of the standard Python package installation, it could also be used standalone
without requiring either Python or `vboxn`_ itself.

Usage
~~~~~

::

    vboxn-init <vm_name> <os_type> <auto|auto64|iso_source_file> [properties_file] [vm_option=..., vm_option=...]

    Description:

        Automate the creation of VirtualBox machine instances.

    Examples:

        vboxn-init testbox0 archlinux auto
        vboxn-init testbox0 archlinux archlinux-2011.08.19-core-i686.iso
        vboxn-init testbox0 archlinux iso/archlinux-2011.08.19-core-i686.iso conf/vm.properties
        vboxn-init testbox0 archlinux auto kickstart=no
        vboxn-init testbox0 archlinux auto kickstart_file=bootstrap.sh
        vboxn-init testbox0 archlinux auto postinstall=no
        vboxn-init testbox0 archlinux auto vm_basefolder=/srv/vbox

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
        guest machine by running "one shot" web servers on the host.
        The default address and port for these web servers to listen on
        is '192.168.1.100:8585' and '192.168.1.100:8586'. This can be
        changed by specifying the 'kickstart_listen_on' and
        'post_install_listen_on' parameters. Eg.

            vboxn-init testbox0 ubuntu auto kickstart_listen_on=10.10.5.1:8080

      - The default wait time for the kickstart and postinstall scripts is
        600 seconds (10 minutes), this can be changed by specifying the
        'kickstart_wait' and 'postinstall_wait' options, eg.

            vboxn-init testbox0 ubuntu auto kickstart_wait=300


.. _vboxn: https://github.com/devopsni/vboxn
.. _veewee: https://github.com/jedi4ever/veewee


