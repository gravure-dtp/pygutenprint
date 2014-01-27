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

"""
Package pygutenprint : a python warper of the libgutenprint API
"""

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

