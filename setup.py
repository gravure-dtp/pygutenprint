# -*- coding: utf-8 -*-

# Copyright (C) 2011 Atelier Obscur.
# Authors:
# Gilles Coissac <dev@atelierobscur.org>

# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License
# as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License with
# the Debian GNU/Linux distribution in file /usr/share/common-licenses/GPL;
# if not, write to the Free Software Foundation, Inc., 51 Franklin St,
# Fifth Floor, Boston, MA 02110-1301, USA.

#from ez_setup import use_setuptools
#from distribute_setup import use_setuptools
#use_setuptools()
#from setuptools import setup, find_packages
#from setuptools.extension import Extension

from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

#
#======================= Compilation paths ===============================
SRC_DIR = 'gravure/pygutenprint/'
INCLUDE_DIRS = ['/usr/include']
DYN_LIBRARY_DIRS = ['/usr/lib', '/usr/lib/x86_64-linux-gnu']
LIBRARIES = ['libgutenprint']
X_LINK_ARGS = [] # -t
EXTRA_OBJECTS = ['/usr/lib/x86_64-linux-gnu/libgutenprint.so']

#
#======================= Extensions list =================================
extensions = [
                Extension('sequence', \
                          [SRC_DIR + 'sequence.pyx'], \
                          include_dirs = INCLUDE_DIRS, \
                          #libraries = LIBRARIES, \
                          runtime_library_dirs=DYN_LIBRARY_DIRS, \
                          extra_objects = EXTRA_OBJECTS \
                          ), \

#                Extension('curve', \
#                          [SRC_DIR + 'curve.pyx'], \
#                          include_dirs = INCLUDE_DIRS, \
#                          libraries = LIBRARIES, \
#                          ), \

                Extension('util', \
                          [SRC_DIR + 'util.pyx'], \
                          include_dirs = INCLUDE_DIRS, \
                          #libraries = LIBRARIES, \
                          runtime_library_dirs=DYN_LIBRARY_DIRS, \
                          extra_objects = EXTRA_OBJECTS \
                          ) \
                ]
#
#=========================== SETUP COMMANDE ===================================
setup(
      name              = 'pygutenprint',
      description       = 'a Python binding to the gutenprint library',
      author            = 'Gilles Coissac',
      author_email      = 'dev@atelierobscur.org',
      maintainer        = 'Gilles Coissac',
      maintainer_email  = 'gilles@atelierobscur.org',
      url               = 'http://www.atelierobscur.org/',
      download_url      = 'http://www.atelierobscur.org/',
      version           = '0.1dev',
      license           = 'LGPL v2',
      #keywords          = '',
      long_description  = open('README.txt').read(),
      #url               = '',
      #classifiers       = [],
      packages          = ['gravure.pygutenprint'],
      namespace_packages = ['gravure'],
      ext_package       = 'gravure.pygutenprint',
      ext_modules       = cythonize(extensions),

      # Project uses reStructuredText, so ensure that the docutils get
      # installed or upgraded on the target machine
      #install_requires = ['docutils>=0.3'],
      #test_suite = '',
      #tests_require = 'nose'
)

