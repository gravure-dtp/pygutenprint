# -*- coding: utf-8 -*-

# $Id: $
# sequence.pxd
# pxd Cython C standard declarations for module pygutenprint
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
#

#include <stdio.h>
#include <stdlib.h>

cdef extern from "stdio.h":
    ctypedef struct FILE
    