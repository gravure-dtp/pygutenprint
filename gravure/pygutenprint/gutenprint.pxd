# -*- coding: utf-8 -*-

# $Id: $
# gutenprint.pxd
# pxd Cython C declarations for module pygutenprint.gutenprint
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


#===============================================================================
# 
#  @file gutenprint/gutenprint.h
#  @brief Gutenprint master header.
#  This header includes all of the public headers.
# 
#===============================================================================

cdef extern from "gutenprint/gutenprint.h": 
    pass


#IF GUTENPRINT_H != 0
#    DEF GUTENPRINT_H = 0
#
#    #--------------------------------------------------------------------------- 
#    # C standard library
#    #
#    # include <stddef.h>     /* For size_t */
#    cdef extern from "stddef.h": pass
#    
#    # include <stdio.h>    /* For FILE */
#    cdef extern from "stdio.h": pass
#    
#    
#    #--------------------------------------------------------------------------- 
#    # Gutunprint public library
#    #
#    # include <gutenprint/array.h>
#    cdef extern from "gutenprint/array.h": pass
#    
#    # include <gutenprint/curve.h>
#    cdef extern from "gutenprint/curve.h": pass
#    
#    # include <gutenprint/gutenprint-version.h>
#    cdef extern from "gutenprint/gutenprint-version.h": pass
#    
#    # include <gutenprint/image.h>
#    cdef extern from "gutenprint/image.h": pass
#    
#    # include <gutenprint/paper.h>
#    cdef extern from "gutenprint/paper.h": pass
#    
#    # include <gutenprint/printers.h>
#    cdef extern from "gutenprint/printers.h": pass
#    
#    # include <gutenprint/sequence.h>
#    cdef extern from "gutenprint/sequence.h": pass
#    
#    # include <gutenprint/string-list.h>
#    cdef extern from "gutenprint/string-list.h": pass
#    
#    # include <gutenprint/util.h>
#    cdef extern from "gutenprint/util.h": pass
#    
#    # include <gutenprint/vars.h>
#    cdef extern from "gutenprint/vars.h": pass
#    
#    
## ENDIF GUTENPRINT_H

