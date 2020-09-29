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

cdef extern from "gutenprint/sequence.h":
    # The sequence opaque data type.
    struct stp_sequence:
        pass
    ctypedef stp_sequence stp_sequence_t

cdef class __AuxBufferInterface:
    cdef bint readonly
    cdef void* buffer
    cdef Py_ssize_t count
    cdef bytes dtype
    cdef Py_ssize_t itemsize
    cdef int ndim
    cdef Py_ssize_t [2] shape
    cdef Py_ssize_t [2] strides
    cdef object obj
    cdef set_buffer(__AuxBufferInterface, bint, void*, \
                    Py_ssize_t, bytes, Py_ssize_t, int, \
                    Py_ssize_t*)

cdef class Sequence:
    cdef stp_sequence_t* _sequence
    cdef __AuxBufferInterface aux_buffer
    cdef int ndim
    cdef Py_ssize_t [2] _shape
    cdef Py_ssize_t [2] _strides
    cpdef copy_in(Sequence, object)
    cpdef object copy(Sequence)
    cpdef set_size(Sequence, object)
    cpdef reverse(Sequence)
    cpdef object create_reverse(Sequence)
    cpdef set_bounds(Sequence, double, double)
    cpdef object get_bounds(Sequence )
    cpdef object get_range(Sequence)
    cpdef double min(Sequence)
    cpdef double max(Sequence)
    cdef stp_sequence* get_sequence(Sequence self)nogil
    cdef bint set_point(Sequence, size_t, double)nogil except 0
    cdef int set_data_c(self, object data, bint count_from_buf)except -1
    cdef int setslice(Sequence self, start, stop, object value)except -1
    cdef void get_c_buffer(Sequence, size_t*, double**)nogil
    cdef void fill_strides_and_shape(Sequence)nogil

cdef int raise_bound_error(char*, double, double) except -1 with gil
cdef int raise_index_error(char*, int) except -1 with gil
cdef int raise_nan_error(char*) except -1 with gil
cdef int raise_attribute_error(char*) except -1 with gil
