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

"""Module gravure.pygutenprint.array.

"""

import cython
cimport cython
from gravure.pygutenprint.sequence import Sequence
from gravure.pygutenprint cimport sequence

__all__= ['Array']

cdef extern from "gutenprint/array.h":
    stp_array_t *stp_array_create(int x_size, int y_size)nogil
    void stp_array_destroy(stp_array_t *array)nogil
    void stp_array_copy(stp_array_t *dest, stp_array_t *source)nogil
    stp_array_t *stp_array_create_copy(stp_array_t *array)nogil
    void stp_array_set_size(stp_array_t *array, int x_size, int y_size)nogil
    void stp_array_get_size(const stp_array_t *array, int *x_size, int *y_size)nogil
    void stp_array_set_data(stp_array_t *array, const double *data)nogil
    void stp_array_get_data(const stp_array_t *array, size_t *size, const double **data)nogil
    int stp_array_set_point(stp_array_t *array, int x, int y, double data)nogil
    int stp_array_get_point(const stp_array_t *array, int x, int y, double *data)nogil
    stp_sequence_t *stp_array_get_sequence(stp_array_t *array)nogil


cdef class Array(Sequence):
    """The array is a simple "two-dimensional array of numbers".

    Array "inherits" from the Sequence object.

    :param data: an optional python array like object to initialize the array.\
    if None the size of the Array will be set with the size paramater.
    :param size: a tuple (x_size, y_size), the total size of the array will be (x_size * y_size).\
    If date was specified, size will have no effect.
    :param low: a number to set the low boundary.
    :param high: a number to set the high boundary.
    :returns: the newly created Array.
    :raises: MemmoryError.
    """

    def __cinit__(Array self, data=None, shape=None, low=None, high=None, *args, **kwargs):
        cdef int xs, ys
        if shape is None:
            xs, ys = (0,0)
        else:
            xs, ys = shape
        self._array = stp_array_create(xs, ys)
        if not self._array:
            raise MemoryError("Unable to create a new array.")
        self.ndim = 2
        self._sequence = stp_array_get_sequence(self._array)

    def __init__(Array self, data=None, low=None, high=None, *args, **kwargs):
        Sequence.__init__(self, None, low, high, args, kwargs)
        if data is not None:
            self.set_data(data)

    def __dealloc__(Array self):
        if self._array is not NULL:
            stp_array_destroy(self._array)

    cdef stp_sequence_t* get_sequence(Array self)nogil:
        return stp_array_get_sequence(self._array)

    #
    # COPY METHODS
    #
    cpdef copy_in(Array self, object dest):
        """Copy this Array in dest.

        dest must be a valid Array previously instancied
        with dest = Array().

        :param dest: dest the destination Array.
        """
        cdef Array d
        if isinstance(dest, Array):
            d = <Array> dest
            stp_array_copy(d._array, self._array)
        else:
            raise ValueError("The Array parameter is not valid")

    cpdef copy(Array self):
        """Return a copy of this Array.

        A new Array will be created, and then the contents
        of self will be copied into it.

        :returns: the new copy of the SeArrayquence.
        """
        cdef Array copy_array
        copy_array = Array()
        stp_array_copy(copy_array._array, self._array)
        return copy_array

    #
    # SIZED INTERFACE
    #
    def __len__(Array self):
        """len(self).

        :returns: the array first dimension.
        """
        cdef int x, y
        stp_array_get_size(self._array, &x, &y)
        return x

    cpdef set_size(Array self, object size):
        """Resize an array.

        Resizing an array will destroy all data stored in the array.

        :param size: a tuple (x_size, y_size) that define the new array shape.
        :raises: MemmoryError.
        """
        stp_array_set_size(self._array, <size_t> size[0], <size_t> size[1])

    property shape:
        """readonly property shape

        :returns: a tuple with the array dimensions.
        """
        def __get__(self):
            cdef int x, y
            stp_array_get_size(self._array, &x, &y)
            return (x, y)

    property strides:
        """readonly property strides

        :returns: A tuple of integers giving the size in bytes to access each element for each dimension of the array
        """
        def __get__(self):
            cdef int  x, y
            y = sizeof(double)
            x = self.__len__() * y
            return (x,y)

    property itemsize:
        """readonly property itemsize

        :returns: A integers giving the size in bytes of each elements.
        """
        def __get__(self):
            return sizeof(double)

    property nbytes:
        """readonly property nbytes

        :returns: The total length in bytes of the array buffer
        """
        def __get__(self):
            cdef int x, y
            stp_array_get_size(self._array, &x, &y)
            return sizeof(double) * x * y

    property size:
        """readonly property size

        :returns: The total number of element in the array
        """
        def __get__(self):
            return self.nbytes / self.itemsize

    def set_data(self, data not None):
        """Set the data in the array.

        :param data: a python array like object implementing the buffer interface.
        :raises: ValueError if None or with an array with a
        not supported type.
        """
        self.set_data_c(data, False)

    cdef void get_c_buffer(Array self, size_t* size_ptr, double** data_ptr)nogil:
        stp_array_get_data(<const stp_array_t*> self._array, size_ptr, <const double**> data_ptr)

    cdef void fill_strides_and_shape(Array self)nogil:
        cdef int x, y
        stp_array_get_size(self._array, &x, &y)
        self._shape[0] = x
        self._shape[1] = y
        self._strides[1] =  sizeof(double)
        self._strides[0] = x * self._strides[1]

    #
    # SEQUENCE INTERFACE : __getitem__(), __setitem__()
    #
    def __setitem__(Array self, object index, object value):
        if isinstance(index, tuple):
            if len(index) > 2:
                raise IndexError("Can’t index Array on more than two dimensions")
            elif len(index) == 1:
                index = tuple([index[0], slice(0, self.shape[1])])
            lst = []
            for i in index:
                if not isinstance(i, slice):
                    if PyIndex_Check(i):
                        lst.append(slice(i, i + 1))
                    else:
                        raise TypeError("Cannot index with type '%s'" % type(i))
                else:
                    lst.append(i)
            index = tuple(lst)
        elif isinstance(index, slice):
            index = tuple([index, slice(0, self.shape[1])])
        elif PyIndex_Check(index):
            index = tuple([index, slice(0, self.shape[1])])
        else:
            raise TypeError("Cannot index with type '%s'" % type(index))

        if self.check_index(index) is not None:
            self.setslice(index, value)
        else:
            return

    cdef int setslice(Array self, tuple index, object value)except -1:
        cdef Py_ssize_t size, i, v, _len
        cdef memoryview mv = None
        cdef Py_buffer pybuffer
        cdef double d_val

        try:
            mv = memoryview(value, PyBUF_ANY_CONTIGUOUS|PyBUF_FORMAT, False)
        except TypeError:
            d_val = <double> value
            for i in xrange(index[0].start, index[0].stop + 1):
                for v in xrange(index[1].start, index[1].stop + 1):
                    self.set_point(i, v, d_val)
        else:
            pass

    cdef bint set_point(Array self, size_t x, size_t y, double value)nogil except 0:
        """Set the data at a single point in a Sequence.

        :param index: position in Sequence (from zero).
        :param value: the datum to set.
        :raises: IndexError, SequenceBoundsError, SequenceNaNError.
        """
        cdef bint retcode
        cdef double low, high

        retcode = stp_array_set_point(self._array, x, y, value)

        if not retcode:
            last_index = stp_sequence_get_size(self._sequence) - 1
            low, high = self.get_bounds()
            if (value < low or value > high):
                raise_bound_error("Attempt to set a value out of bounds (%f, %f)", low, high)
            else:
                raise_attribute_error("Invalid argument(s)")
        return 1








