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

import os
import sys
import multiprocessing as mp

import ez_setup
ez_setup.use_setuptools()
import setuptools
from setuptools import setup
from setuptools.extension import Extension
from setuptools.command import build_ext

MIN_CYTHON_VERSION = '0.19'
MIN_PYTHON_VERSION = (3, 4)
CPU_COUNT = mp.cpu_count()

# Redirection of cython compilation errors in file
sys.stderr = open('.errors_log', 'w')

# Cython requierement
try:
    import Cython
    from Cython.Distutils import Extension
    has_cython = True
except:
    has_cython = False
devtree = os.path.exists('DEVTREE')

# extensions compilation scheme
if devtree:
    # we are not in a source distribution tree
    # cython min version is an absolute requirement.
    try:
        setuptools.dist.Distribution(dict(setup_requires=['cython>=' + MIN_CYTHON_VERSION]))
    except:
        print("At least Cython %s is needed to generate c extensions files!" % (MIN_CYTHON_VERSION, ))
        sys.exit(1)
#    else:
#        use_cython = True
#else:
    # we are in a source distribution
    # and pyx files extensions should be already cythonized.
#    if has_cython and Cython.__version__ >= MIN_CYTHON_VERSION:
        # Cython is present and match minimum version
        # so we could use it.
#        use_cython = True
#    else:
        # let distribute or setuptools try to build against c files.
 #       use_cython = False    #package_data = {'gravure/pygutenprint': ['*.pxd']},    


#if use_cython:
#    print("Cython %s is detected so generate c extensions files if needed." % (Cython.__version__, ))
#    from Cython.Build import cythonize 
#    #from Cython.Distutils import build_ext
#    #TODO: make cython don't leave c generated files in the dev source tree
#    def get_extensions(extensions, **_ignore):
#        print("Cythonyze ...")
#        #Cython.Compiler.Options.docstrings = True
#        #Cython.Compiler.Options.emit_code_comments = True
#        return cythonize(module_list=extensions, nthreads=CPU_COUNT-2 , language_level=3, force=True)
#else:
#    print("Cython %s is not present but try to continue without it..." % (MIN_CYTHON_VERSION, ))
#    def get_extensions(extensions, **_ignore):
#        for extension in extensions:
#            sources = []
#            for sfile in extension.sources:
#                path, ext = os.path.splitext(sfile)
#                if ext in ('.pyx', '.py'):
#                    if extension.language == 'c++':
#                        ext = '.cpp'
#                    else:
#                        ext = '.c'
#                    sfile = path + ext
#                sources.append(sfile)
#            extension.sources[:] = sources
#        return extensions

#
#=== Python version ===================
if sys.version_info[0] == MIN_PYTHON_VERSION[0]:
    if sys.version_info[1] < MIN_PYTHON_VERSION[1]:
        print("You need Python %i.%i or greater" %MIN_PYTHON_VERSION)
        sys.exit(1)
elif sys.version_info[0] < MIN_PYTHON_VERSION[0]:
    print("You need Python %i.%i or greater" %MIN_PYTHON_VERSION)
    sys.exit(1)
    

    
#
#======================= Compilation paths ===============================
SRC_DIR = 'gravure/pygutenprint'
INCLUDE_DIRS = ['/usr/include', 'include', SRC_DIR]
DYN_LIBRARY_DIRS = ['/usr/lib', '/usr/lib/x86_64-linux-gnu']
#TODO: make this platform independant
LIBRARIES = [] #['libgutenprint']
EXTRA_OBJECTS = ['/usr/lib/x86_64-linux-gnu/libgutenprint.so.9']
COMPILE_ARGS =[]
X_LINK_ARGS = [] 
CYTHON_DIRECTIVES = {'language_level':3, 'embedsignature':False}

#
#=== package version ===================
version = open('VERSION').read().strip()
open(os.path.join(SRC_DIR,'version.py'), 'w').write('__version__ = "%s"\n' % version)

#
#======================= Extensions list =================================
extensions = [ \
    Extension(\
        'sequence', \
        sources = [os.path.join(SRC_DIR, 'sequence.pyx')], \
        include_dirs = INCLUDE_DIRS, \
        libraries = LIBRARIES, \
        runtime_library_dirs = DYN_LIBRARY_DIRS, \
        extra_objects = EXTRA_OBJECTS, \
        cython_directives = CYTHON_DIRECTIVES \
    ), \
    Extension(\
        'array', \
        sources = [os.path.join(SRC_DIR, 'array.pyx')], \
        include_dirs = INCLUDE_DIRS, \
        libraries = LIBRARIES, \
        runtime_library_dirs = DYN_LIBRARY_DIRS, \
        extra_objects = EXTRA_OBJECTS, \
        cython_directives = CYTHON_DIRECTIVES \
    ), \
#   Extension(
#       'curve', \
#       sources = [os.path.join(SRC_DIR, 'curve.pyx')], \
#       include_dirs = INCLUDE_DIRS, \
#       libraries = LIBRARIES, \
#   ), \
    Extension('util', \
        sources = [os.path.join(SRC_DIR, 'util.pyx')], \
        include_dirs = INCLUDE_DIRS, \
        libraries = LIBRARIES, \
        runtime_library_dirs = DYN_LIBRARY_DIRS, \
        extra_objects = EXTRA_OBJECTS, \
        cython_directives = CYTHON_DIRECTIVES \
    ) \
]

#extensions = get_extensions(extensions)

#
#=========================== SETUP COMMANDE ===================================
setup(
    name              = 'gravure.pygutenprint',
    version           = version,
    platforms         = ['any'],
    
    packages = ['gravure.pygutenprint'],
    ext_modules = extensions,
    #package_data = {'pygutenprint': ['*.pxd']},
    zip_safe = False,
    
    #test_suite = '',
    #tests_require = 'nose'

    # Project uses reStructuredText,
    # and sphinx 1.1
    # install_requires = ['sphinx>=1.1'],
    
    author            = 'Gilles Coissac',
    author_email      = 'dev@atelierobscur.org',
    maintainer        = 'Gilles Coissac',
    maintainer_email  = 'dev@atelierobscur.org',
    description       = 'a Python binding to the gutenprint library',  
    long_description  = open('README.txt').read(),
    license           = 'LGPL v3',
    keywords          = "print rip printer driver gutenprint",
    url               = 'http://www.atelierobscur.org/',
    download_url      = 'http://www.atelierobscur.org/',
    classifiers=[
        "Environment :: X11 Applications :: Gnome",
        "Environment :: X11 Applications :: GTK",
        "Intended Audience :: End Users/Desktop",
        "Natural Language :: English",
        "Operating System :: POSIX :: Linux",
        "Programming Language :: C",
        "Programming Language :: Cython",
        "Programming Language :: Python",
        "Programming Language :: Python :: 3.4",
        "Topic :: Artistic Software",
        "Topic :: Desktop Environment :: Gnome",
        "Topic :: Printing",
        "Topic :: Software Development :: Libraries :: Python Modules"
    ]
)