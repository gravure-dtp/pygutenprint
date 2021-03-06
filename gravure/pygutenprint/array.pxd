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

from gravure.pygutenprint.sequence cimport *

cdef extern from "gutenprint/array.h":
    # The array opaque data type.
    struct stp_array:
        pass
    ctypedef stp_array stp_array_t


cdef class Array(Sequence):
        cdef stp_array_t* _array

        cdef stp_sequence* get_sequence(Array)nogil
        cdef void get_c_buffer(Array, size_t*, double**)nogil
        cdef void fill_strides_and_shape(Array)nogil

        cpdef copy_in(Array, object)
        cpdef copy(Array)
        cpdef set_size(Array, object)

        cdef int setslice(Array, tuple, object)except -1
        cdef bint set_point(Array, size_t, size_t, double)nogil except 0
        cdef bint check_index(Array, tuple)


