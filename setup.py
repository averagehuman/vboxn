# -*- coding: utf-8 -*-

from distutils.core import setup

__version__ = '0.0.1'

readme = open("README.rst").read()
changes = open("docs/changes.rst").read()
long_description = readme + "\n\n" + changes


setup(
    name="vboxn",
    version=__version__,
    description="Automate the creation and provisioning of VirtualBox machines.",
    author="Gerard Flanagan",
    author_email="contact@devopsni.com",
    long_description=long_description,
    classifiers=["Development Status :: 1 - Planning",
                "Programming Language :: Python",
                "Programming Language :: Shell",
                ],
    package_dir = {'': 'src'},
    packages = ['vboxn'],
    scripts=[
        'scripts/vboxn-init',
        'scripts/vboxn-postinstall',
        'scripts/vboxn-scancodes',
        'scripts/vboxn',
    ]
)
    

