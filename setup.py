# -*- coding: utf-8 -*-

from setuptools import setup, find_packages

__init__ = open('vboxn/__init__.py').read().splitlines()

def meta(key):
    for line in __init__:
        if line.startswith(key):
            return line.partition('=')[2].strip().strip("'").strip('"')

__version__ = meta('__version__')

readme = open("README.rst").read()
changes = open("docs/changes.rst").read()
long_description = readme + "\n\n" + changes


setup(
    name="vboxn",
    version=__version__,
    description="Automate the creation and provisioning of VirtualBox machines.",
    author="Gerard Flanagan",
    author_email="gflanagan@devopsni.com",
    long_description=long_description,
    classifiers=[
                "Programming Language :: Python",
                "Programming Language :: Other",
                "Environment :: Console",
                "Operating System :: POSIX",
                ],
    packages = find_packages(),
    scripts=[
        'scripts/vboxn-init',
        'scripts/vboxn-postinstall',
        'scripts/vboxn-scancodes',
        'scripts/vboxn',
    ],
    install_requires=[
        "cliff",
    ],
    url="https://github.com/devopsni/vboxn",
    license="BSD",
    download_url="http://pypi.python.org/packages/source/v/vboxn/vboxn-%s.tar.gz" % __version__,
)
    

