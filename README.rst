
vboxen
######

`vboxen`_ automates the creation of VirtualBox machines.

Overiew
=======

`vboxen`_ is a Python/Bash library for headlessly creating new VirtualBox machine
images.  It is intended as a developer utility similar to `veewee`_.

`vboxen`_ includes two user-facing scripts - **vboxen-init** for creating and
bootstrapping a new virtual machine, and **vboxen** for manipulating existing
machines.

Installation
============

Install the development version with pip::

    pip install -e git+https://github.com/podados/vboxen.git#egg=vboxen


vboxen-init
===========

**vboxen-init** is a Bash script and, although it will be installed as part
of the standard Python package installation, it could also be used standalone
without requiring either Python or `vboxen`_ itself.

Usage
~~~~~

::

    vboxen-init <vm_name> <os_type> <auto|iso_source_file> [properties_file] [vm_option=..., vm_option=...]

    Description:

        Automate the creation of VirtualBox machine instances.

    Examples:

        vboxen-init testbox0 archlinux auto
        vboxen-init testbox0 archlinux archlinux-2011.08.19-core-i686.iso
        vboxen-init testbox0 archlinux iso/archlinux-2011.08.19-core-i686.iso conf/vm.properties
        vboxen-init testbox0 archlinux auto kickstart=no
        vboxen-init testbox0 archlinux auto kickstart_file=bootstrap.sh
        vboxen-init testbox0 archlinux auto postinstall=no
        vboxen-init testbox0 archlinux auto vm_basefolder=/srv/vbox

    Notes:

        - Specifying 'auto' for the iso source will download the latest generic
          32-bit installation image for the OS

        - A properties file can optionally be used to supply overrides to the
          default VM config options, it is sourced by vboxen-init and should be a
          valid shell script.

        - If Python is installed, properties can additionally be defined as
          command line arguments. If both a properties file and command line
          properties are given, then those specified on the command line will
          take precedence. Spaces in argument values must be backslash-escaped.

        - If 'kickstart=yes' (the default) and 'kickstart_file' is
          unspecified, then a generic kickstart file will be downloaded
          from this project's github repository and run on the new guest
          machine. Similarly for 'postinstall=yes' and 'postinstall_configure_files'.

        - 'postinstall_configure_files' should be a space-delimited list
          of files which will be concatenated in the order given and run
          on the guest after the OS is installed.


.. _vboxen: https://github.com/podados/vboxen
.. _veewee: https://github.com/jedi4ever/veewee


