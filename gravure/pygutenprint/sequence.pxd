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

cdef class Sequence:
    cdef stp_sequence_t* _sequence
    cpdef copy_in(Sequence, Sequence)
    cpdef object copy(Sequence)
    cpdef set_size(Sequence, Py_ssize_t)
    cpdef reverse(Sequence)
    cpdef object create_reverse(Sequence)
    cpdef set_bounds(Sequence, double, double)
    cpdef object get_bounds(Sequence )
    cpdef object get_range(Sequence)
    cpdef double min(Sequence)
    cpdef double max(Sequence)
    cdef set_point(Sequence, Py_ssize_t, double)

    cdef set_slice(Sequence, object, object, bint)
    cdef is_slice(Sequence, object)





