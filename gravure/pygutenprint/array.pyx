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

#cython: embedsignature=True

"""Module gravure.pygutenprint.array.

"""

import cython
cimport cython
from gravure.pygutenprint.sequence import Sequence

__all__= ['Array']

cdef extern from "gutenprint/array.h":
    #extern stp_array_t *stp_array_create(int x_size, int y_size);
    #extern void stp_array_destroy(stp_array_t *array);
    #extern void stp_array_copy(stp_array_t *dest, const stp_array_t *source);
    #extern stp_array_t *stp_array_create_copy(const stp_array_t *array);
    #extern void stp_array_set_size(stp_array_t *array, int x_size, int y_size);
    #extern void stp_array_get_size(const stp_array_t *array, int *x_size, int *y_size);
    #extern void stp_array_set_data(stp_array_t *array, const double *data);
    #extern void stp_array_get_data(const stp_array_t *array, size_t *size, const double **data);
    #extern int stp_array_set_point(stp_array_t *array, int x, int y, double data);
    #extern int stp_array_get_point(const stp_array_t *array, int x, int y, double *data);
     stp_sequence_t *stp_array_get_sequence(stp_array_t *array)nogil


cdef class Array(Sequence):
    """The array is a simple "two-dimensional array of numbers".

    Array "inherits" from Sequence object.
    """

    def __cinit__(Array self, *args, **kwargs):
        pass

    cdef stp_sequence_t* get_sequence(Array self)nogil:
        return stp_array_get_sequence(self._array)



