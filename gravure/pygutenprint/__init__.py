#! /usr/bin/env python

# -*- coding: utf-8 -*-
# $Id: $
# Package pygutenprint
#
#   This program is free software; you can redistribute it and/or modify it
#   under the terms of the GNU General Public License as published by the Free
#   Software Foundation; either version 2 of the License, or (at your option)
#   any later version.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.
#
#   Provided as-is; use at your own risk; no warranty; no promises; enjoy!
#
# TODO : all
#
"""
Package pygutenprint : a python warper of the libgutenprint API
"""

__author__ = "Gilles Coissac <gilles@atelierobscur.org>"
__date__ = "4 May 2010"
__version__ = "$Revision: 0.1 $"
__credits__ = "Atelier Obscur : www.atelierobscur.org"




#import gutenprint
#import util


def init():
    """Initialise libgimpprint.
    
    This function prior exist in module pygutenprint.util. This a
    convenient short's cut.
    
    This function must be called prior to any other use of the library.
    It is responsible for loading modules and XML data and initialising
    internal data structures.
    
    Returns : True on success
              False on failure
    """
    return util.init()

