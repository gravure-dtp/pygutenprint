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

"""Module gravure.pygutenprint.sequence.

Curve code borrowed from GTK+, http://www.gtk.org/
"""

import cython
cimport cython


__all__ = ['Sequence', 'SequenceBoundsError', 'SequenceIndexError', \
                'SequenceNaNError', 'SequenceTypeError']

cdef extern from "Python.h":
    bint PyIndex_Check(object o)
    # Returns True if o is an index integer (has the nb_index slot of
    # the tp_as_number structure filled in).

    bint PyObject_CheckBuffer(object obj)
    # Return 1 if obj supports the buffer interface otherwise 0.

    int PyObject_GetBuffer(object obj, Py_buffer *view, int flags) except -1

    bint PyBuffer_IsContiguous(Py_buffer *view, char fort)
    # Return 1 if the memory defined by the view is C-style (fortran
    # is 'C') or Fortran-style (fortran is 'F') contiguous or either
    # one (fortran is 'A'). Return 0 otherwise.

    void PyBuffer_Release(Py_buffer *view)
    # Release the buffer view. This should be called when the buffer
    # is no longer being used as it may free memory from it.

    cdef enum:
        PyBUF_SIMPLE,
        PyBUF_WRITABLE,
        PyBUF_WRITEABLE, # backwards compatability
        PyBUF_FORMAT,
        PyBUF_ND,
        PyBUF_STRIDES,
        PyBUF_C_CONTIGUOUS,
        PyBUF_F_CONTIGUOUS,
        PyBUF_ANY_CONTIGUOUS,
        PyBUF_INDIRECT,
        PyBUF_CONTIG,
        PyBUF_CONTIG_RO,
        PyBUF_STRIDED,
        PyBUF_STRIDED_RO,
        PyBUF_RECORDS,
        PyBUF_RECORDS_RO,
        PyBUF_FULL,
        PyBUF_FULL_RO,
        PyBUF_READ,
        PyBUF_WRITE,
        PyBUF_SHADOW

cdef extern from "pyport.h":
    ctypedef Py_ssize_t Py_intptr_t

cdef extern from *:
    int __Pyx_GetBuffer(object, Py_buffer *, int) except -1
    void __Pyx_ReleaseBuffer(Py_buffer *)

    ctypedef struct PyObject
    void Py_INCREF(PyObject *)
    void Py_DECREF(PyObject *)

    ctypedef struct __pyx_buffer "Py_buffer":
        PyObject *obj

    PyObject *Py_None

cdef extern from "stdlib.h":
    void *malloc(size_t) nogil
    void free(void *) nogil
    void realloc(void *, size_t) nogil
    void *memcpy(void *dest, void *src, size_t n) nogil

cdef extern from "gutenprint/sequence.h":
    stp_sequence_t* stp_sequence_create() nogil
    void stp_sequence_destroy(stp_sequence_t* sequence) nogil
    void stp_sequence_copy(stp_sequence_t* dest, stp_sequence_t* source) nogil
    stp_sequence_t* stp_sequence_create_copy(stp_sequence_t* sequence) nogil
    void stp_sequence_reverse(stp_sequence_t* dest, stp_sequence_t* source) nogil
    stp_sequence_t* stp_sequence_create_reverse(stp_sequence_t* sequence) nogil
    bint stp_sequence_set_bounds(stp_sequence_t* sequence, double low, double high) nogil
    void stp_sequence_get_bounds(stp_sequence_t* sequence, double* low, double* high) nogil
    void stp_sequence_get_range(stp_sequence_t* sequence, double* low, double* high) nogil
    bint stp_sequence_set_size(stp_sequence_t* sequence, size_t size) nogil
    size_t stp_sequence_get_size(stp_sequence_t* sequence) nogil
    bint stp_sequence_set_data(stp_sequence_t* sequence, size_t count, double* data) nogil
    # extern int stp_sequence_set_subrange(stp_sequence_t *sequence, size_t where, size_t size, const double *data);
    void stp_sequence_get_data(const stp_sequence_t* sequence, size_t* size, const double** data) nogil
    bint stp_sequence_set_point(stp_sequence_t* sequence, size_t where, double data) nogil
    bint stp_sequence_get_point(stp_sequence_t* sequence, size_t where, double* data) nogil
    bint stp_sequence_set_float_data(stp_sequence_t* sequence, size_t count, float* data) nogil
    bint stp_sequence_set_long_data(stp_sequence_t* sequence, size_t count, long* data) nogil
    bint stp_sequence_set_ulong_data(stp_sequence_t* sequence, size_t count, unsigned long* data) nogil
    bint stp_sequence_set_int_data(stp_sequence_t* sequence, size_t count, int* data) nogil
    bint stp_sequence_set_uint_data(stp_sequence_t* sequence, size_t count, unsigned int* data) nogil
    bint stp_sequence_set_short_data(stp_sequence_t* sequence, size_t count, short* data) nogil
    bint stp_sequence_set_ushort_data(stp_sequence_t* sequence, size_t count, unsigned short* data) nogil
    float* stp_sequence_get_float_data(stp_sequence_t *sequence, size_t *count) nogil
    long* stp_sequence_get_long_data(stp_sequence_t *sequence, size_t *count) nogil
    unsigned long* stp_sequence_get_ulong_data(stp_sequence_t *sequence, size_t *count)nogil
    int* stp_sequence_get_int_data(stp_sequence_t *sequence, size_t *count) nogil
    unsigned int* stp_sequence_get_uint_data(stp_sequence_t *sequence, size_t *count)nogil
    short* stp_sequence_get_short_data(stp_sequence_t *sequence, size_t *count) nogil
    unsigned short* stp_sequence_get_ushort_data(stp_sequence_t *sequence, size_t *count)nogil

#
# sequence Exceptions Class
#
class SequenceBoundsError(Exception):
    pass

class SequenceNaNError(Exception):
    pass


#
# The Sequence Iterator
#
cdef class SequenceIterator:
    cdef :
        size_t index, direction, length
        Sequence sequence

    def __cinit__(self):
        self.index = 0
        self.direction = 1
        self.length = 0
        #self.sequence = NULL

    def __init__(self, Sequence s, bint reverse=0):
        self.sequence = s
        cdef stp_sequence_t* _s
        _s = self.sequence._sequence

        if (_s is not NULL):
            self.length = stp_sequence_get_size(_s)
            if (reverse):
                self.direction = -1
                self.index = self.length - 1
        else:
            raise ValueError('Can\'t iterate NULL data')

    def __dealloc__(self):
    #        self.index = NULL
    #        self.direction = NULL
    #        self.length = NULL
    #        self.sequence = NULL
            pass

    def __iter__(self):
        return self

    def __next__(self):
        cdef stp_sequence_t* _s
        _s = self.sequence._sequence

        if (_s is NULL):
            raise ValueError('Can\'t iterate NULL data')
        elif (self.index >= self.length or self.index < 0):
            raise StopIteration()

        cdef double data
        cdef bint bool_retcode
        bool_retcode = stp_sequence_get_point(_s, self.index, &data)
        if not bool_retcode:
            raise SystemError('Abnormal Stop Iteration...')
        self.index += self.direction
        return data


cdef class Sequence:
    """
    The Sequence is a simple vector of numbers data structure.

    :param data: an optional python array like object to initialize the Sequence.\
    if None the return Sequence will be empty.
    :param low: a number to set the low boundary.
    :param high: a number to set the high boundary.
    :returns: the newly created Sequence.
    :raises: MemmoryError.
    """

    def __cinit__(Sequence self, data=None, low=None, high=None, *args, **kwargs):
        if self.__class__ == Sequence:
            self._sequence = stp_sequence_create()
            if not self._sequence:
                raise MemoryError("Unable to create a new sequence.")
            self.ndim = 1
        self.aux_buffer = __AuxBufferInterface(self)

    def __init__(Sequence self, data=None, low=None, high=None, *args, **kwargs):
        if low is not None and high is not None:
            self.set_bounds(low, high)
        if data:
            self.set_data(data)

    def __dealloc__(Sequence self):
        if self._sequence is not NULL:
            stp_sequence_destroy(self._sequence)

    cdef stp_sequence_t* get_sequence(Sequence self)nogil:
        return self._sequence

    #
    # STRING REPRESENTATION
    #
    def __str__(self):
        """Get the String representation of the Sequence.

        str(Sequence) return the same as repr(sequence)

        :returns: a string
        """
        return self.__repr__()

    def __repr__(Sequence self):
        """Get the String representation of the Sequence.

        Return a string representing the Sequence.
        You could do : new_S = eval(repr(Sequence)),
        creating a new valid Sequence Object,
        with new_S == Sequence.

        :returns: a string
        """
        _str = "Sequence(data=["
        if self.__len__():
            for i in range(self.__len__() - 1):
                _str += "%f, " %self[i]
            _str += "%f" %self[-1]
        _str += "], low=%f, high=%f)" %self.get_bounds()
        return _str

    #
    # COPY METHODS
    #
    cpdef copy_in(Sequence self, object dest):
        """Copy this Sequence in dest.

        dest must be a valid Sequence previously instancied
        with dest = Sequence().

        :param dest: dest the destination Sequence.
        """
        cdef Sequence s
        if isinstance(dest, Sequence):
            s = <Sequence> dest
            stp_sequence_copy(s._sequence, self._sequence)
        else:
            raise ValueError("The Sequence parameter is not valid")

    cpdef copy(Sequence self):
        """Return a copy of this Sequence.

        A new sequence will be created, and then the contents
        of self will be copied into it.

        :returns: the new copy of the Sequence.
        """
        cdef Sequence copy_sequence
        copy_sequence = Sequence()
        stp_sequence_copy(copy_sequence._sequence, self._sequence)
        return copy_sequence

    #
    # SIZED INTERFACE
    #
    def __len__(Sequence self):
        """len(self).

        :returns: the sequence size.
        """
        return <Py_ssize_t> stp_sequence_get_size(self._sequence)

    cpdef set_size(Sequence self,  object size):
        """Set the sequence size.

        The size is the number of elements the sequence contains.
        Note! : that resizing will destroy all data contained
        in the sequence.

        :param size: the size to set the sequence to.
        :raises: MemmoryError.
        """
        cdef bint retcode
        retcode = stp_sequence_set_size(self._sequence, <size_t> size)
        if not retcode:
            raise MemoryError("Unable to resize this sequence.")

    #
    # ITERATOR INTERFACE
    #
    def __iter__(self):
        """Return: iterator for sequence.
        """
        return SequenceIterator(self)

    #
    # CONTAINER INTERFACE
    #
    def __contains__(Sequence self, double item):
        """Membership testing

        :returns: True or False.
        """
        cdef double data
        cdef  bint ret_code
        cdef size_t index, length
        cdef stp_sequence* s = self.get_sequence()

        ret_code = 0
        length = stp_sequence_get_size(s)
        for index in range(length):
            stp_sequence_get_point(s, index, &data)
            if (data == item):
                ret_code = 1
                break
        return ret_code

    cpdef reverse(Sequence self):
        """Reverse the sequence in place.

        Note : this is a different behavior from the c implementation function.
        The c function stp_reverse() copy the reversed data in a destination
        structure without touching the source. The c api doesn't provide
        in place function.
        """
        cdef stp_sequence_t* seq_rev
        cdef stp_sequence* s = self.get_sequence()
        cdef double* data
        cdef size_t size
        seq_rev = stp_sequence_create_reverse(s)
        stp_sequence_get_data(seq_rev, &size, &data)
        stp_sequence_set_data(s, size, data)

    cpdef create_reverse(Sequence self):
        """Return a reversed copy.

        A new Sequence will be returned with the reverse contents
        of self being copied into it.

        :returns: the new copy of the Sequence.
        """
        reverse = type(self)()
        cdef Sequence rs = <Sequence> reverse
        cdef stp_sequence* s = self.get_sequence()
        reverse_sequence = Sequence()
        stp_sequence_reverse(rs.get_sequence(), s)
        return reverse

    #
    # BOUNDARY METHODS
    #
    cpdef set_bounds(Sequence self, double low, double high):
        """Set the lower and upper bounds.

        The lower and upper bounds set the minimum and maximum values
        that a point in the sequence may hold.

        :param low: the float min value for the lower bound.
        :param high: the float max value for the upper bound.
        :raises: ValueError if the lower bound is greater than
        the upper bound.
        """
        cdef bint retcode
        retcode = stp_sequence_set_bounds(self.get_sequence(), low, high)
        if not retcode:
            raise ValueError('the lower bound is greater than the \
                  upper bound : %f, %f' %(low, high))

    cpdef get_bounds(Sequence self):
        """Get the lower and upper bounds.

        :returns: a tuple of floats bounds values, (min, max).
        """
        cdef double low, high
        stp_sequence_get_bounds(self.get_sequence(), &low, &high)
        return low, high

    cpdef get_range(Sequence self):
        """Get range of values stored in the sequence.

        :returns: a tuple of floats values (min, max).
        """
        cdef double cmin, cmax
        stp_sequence_get_range(self.get_sequence(), &cmin, &cmax)
        return cmin, cmax

    cpdef double min(Sequence self):
        """Get the min value stored in the sequence.

        :returns: a float for the low bound.
        """
        cdef double cmin, cmax
        stp_sequence_get_range(self.get_sequence(), &cmin, &cmax)
        return cmin

    cpdef double max(Sequence self):
        """Get the max value stored in the sequence.

        :returns: a float for the high bound.
        """
        cdef double cmin, cmax
        stp_sequence_get_range(self.get_sequence(), &cmin, &cmax)
        return cmax

    #
    # SEQUENCE INTERFACE : __getitem__(), __setitem__()
    #
    def __setitem__(Sequence self, object index, object value):
        if isinstance(index, slice):
            obj = is_slice(value)
            if obj:
                self.set_slice(index, obj, True)
            else:
                self.set_slice(index, value, False)
        elif PyIndex_Check(index):
            if index < 0:
                index += self.__len__()
                if index < 0:
                    raise IndexError("Index out of bounds.")
            self.set_point(index, value)
        else:
            raise TypeError("Cannot index with type '%s'" % type(index))

    cdef int set_slice(Sequence self, object index, object value, bint val_is_slice)except -1:
        cdef Py_ssize_t start, stop, size, i, v, _len
        cdef cython.view.memoryview mv
        cdef Py_buffer pybuffer
        cdef double d_val

        if index.step != 1 and index.step is not None:
            raise ValueError("step in slice is not implemented")
        _len = self.__len__( )
        if index.start == None:
            start = 0
        elif index.start < 0:
            start = index.start + _len
            if start < 0:
                start = 0
        elif index.start > _len:
            start = _len
        else:
            start = index.start

        if index.stop == None:
            stop = _len - 1
        elif index.stop < 0:
            stop = index.stop + _len
            if stop < 0:
                stop = 0
        elif index.stop > _len:
            stop = _len
        else:
            stop = index.stop

        if stop <= start:
            return 1
        size = stop - start
        v = 0

        if val_is_slice:
            mv = <cython.view.memoryview> value
            PyObject_GetBuffer(mv, &pybuffer, PyBUF_ND)
            if pybuffer.ndim != 1:
                PyBuffer_Release(&pybuffer)
                raise ValueError("Multidimentionnal array is not accepted.")
            if pybuffer.shape[0] >= size:
                for i in xrange(start, stop):
                    if not self.set_point(i, <double> mv[v]):
                        PyBuffer_Release(&pybuffer)
                    v += 1
                PyBuffer_Release(&pybuffer)
            else:
                PyBuffer_Release(&pybuffer)
                raise ValueError("The array provided is too short.")
        else:
            d_val = <double> value
            for i in xrange(start, stop + 1):
                self.set_point(i, d_val)

    cdef bint set_point(Sequence self, size_t index, double value)nogil except 0:
        """Set the data at a single point in a Sequence.

        :param index: position in Sequence (from zero).
        :param value: the datum to set.
        :raises: IndexError, SequenceBoundsError, SequenceNaNError.
        """
        cdef bint retcode
        cdef double low, high
        cdef size_t last_index

        retcode = stp_sequence_set_point(self._sequence, index, value)
        if not retcode:
            last_index = stp_sequence_get_size(self._sequence) - 1
            stp_sequence_get_bounds(self._sequence, &low, &high)
            if (value < low or value > high):
                raise_bound_error("Attempt to set value out of bounds (%f, %f)", low, high)
            elif (index>last_index or last_index<0):
                raise_index_error("[%d], Sequence index out of range", index)
            else:
                raise_nan_error("Sequence value is not a finite number")
        return 1

    def __getitem__(self, index):
        """self[index].

        Get the data at a single point in a Sequence.

        :param index: index, position in Sequence (from zero).
        :raises: SequenceIndexError, TypeError.
        :returns: a Python float value or a Python memoryview of the sliced Sequence.
        """
        cdef double data
        cdef Py_ssize_t py_index
        cdef bint ret_code

        if (isinstance(index, slice)):
            return self.memview.__getitem__(index)
        elif PyIndex_Check(index):
            if index < 0:
                index += self.__len__()
                if index < 0:
                    raise IndexError("Index out of bounds.")
            ret_code = stp_sequence_get_point(self._sequence, <size_t> index, &data)
            if not ret_code:
                raise IndexError('[%d], Sequence index out of range' %index)
            return data
        else:
            raise TypeError('Sequence indices must be integers, not %s' %type(index).__name__)

    #
    # BUFFER INTERFACE [PEP 3118]
    #
    property nbytes:
        """readonly property nbytes

        :returns: The total length in bytes of the sequence buffer
        """
        def __get__(self):
            return stp_sequence_get_size(self._sequence) * sizeof(double)

    property size:
        """readonly property size

        :returns: The total number of element in the sequence
        """
        def __get__(self):
            return stp_sequence_get_size(self._sequence)

    property shape:
        """readonly property shape

        :returns: a tuple with the sequence dimension.
        """
        def __get__(self):
            return (stp_sequence_get_size(self._sequence),)

    cdef void get_c_buffer(Sequence self, size_t* size_ptr, double** data_ptr)nogil:
        stp_sequence_get_data(<const stp_sequence_t*> self._sequence, size_ptr, <const double**> data_ptr)

    cdef void fill_strides_and_shape(Sequence.self)nogil:
        self._shape[0] =  stp_sequence_get_size(self._sequence)
        self._strides[0] =  sizeof(double)

    def __getbuffer__(Sequence self, Py_buffer *info, int flags):
        cdef size_t ret_size
        cdef double* data_buf

        self.get_c_buffer(&ret_size, &data_buf)
        self.fill_strides_and_shape()
        info.buf = <void*> data_buf
        info.len = self.nbytes
        info.readonly = 0
        info.ndim = self.ndim
        info.format = b'd'
        info.shape = self._shape
        info.strides = self._strides
        info.suboffsets = NULL  # we are always direct memory buffer
        info.itemsize = sizeof(double)
        info.obj = self
        info.internal = NULL

        if flags & PyBUF_WRITABLE:
            info.readonly = 0
        else:
            info.readonly = 1

        if flags & PyBUF_SIMPLE:
            # The format of data is assumed to be
            # raw unsigned bytes, without any particular structure,
            # interpreted as one dimentional array (strides=NULL)
            # The buffer exposes a read-only memory area.
            # Data is always contigous.
            info.shape = NULL
            info.strides = NULL
            info.format = NULL  # mean 'B', unsigned byte
            # The 'itemsize' field may be wrong
            return

        if not (flags & PyBUF_ND):
                info.shape = NULL

        if not (flags & PyBUF_STRIDES):
                info.strides = NULL

        cdef int bufmode = -1
        if not (flags & bufmode):
            raise BufferError("Can only create a buffer that is contiguous in memory.")

        if not (flags & PyBUF_FORMAT):
            info.format = NULL

    property memview:
        """Property memview.

        :returns: a python memoryview to access data buffer of the Sequence.\
        Same as get_data().
        """
        def __get__(self):
            # Make this a property as 'self.data' may be set after instantiation
            flags =  PyBUF_C_CONTIGUOUS|PyBUF_FORMAT|PyBUF_WRITABLE
            cdef cython.view.memoryview mv = cython.view.memoryview(self, flags, False)
            return mv

    def get_data(self):
        """Get acces to the data buffer for this sequence.

        :returns: a Python memoryview.
        """
        return self.memview

    def get_float_data(self):
        """Get acces to the data in a sequence as float data buffer.

        The memoryview returned is not guaranteed
        to be valid beyond the next non-const curve call;
        If the bounds of the curve exceed the limits of the data type,
        None is returned.

        :returns: a read only Python memoryview or None
        """
        cdef size_t count
        cdef float *data
        cdef stp_sequence_t * s = self.get_sequence()

        data = stp_sequence_get_float_data(s, &count)
        if data == NULL:
           return None
        self.fill_strides_and_shape()
        self.aux_buffer.set_buffer(True, <void*> data, count, b'f', \
                                 sizeof(float), self.ndim, self._shape)
        cdef cython.view.memoryview mv = cython.view.memoryview(self.aux_buffer, PyBUF_CONTIG_RO, False)
        return mv

    def set_data(self, data not None):
        """Set the data in a sequence.

        :param data: a python object implementing the buffer interface.
        :raises: ValueError if None or with an array with a
        not supported type.
        """
        self.set_data_c(data, True)

    cdef int set_data_c(self, object data, bint count_from_buf)except -1:
        cdef Py_buffer pybuffer
        cdef char *c_type
        cdef size_t sz, count
        cdef bint err_code = 1
        cdef bint release_buff = 0
        cdef int err
        cdef stp_sequence* s = self.get_sequence()

        if PyObject_CheckBuffer(data):
            err = PyObject_GetBuffer(data, &pybuffer, PyBUF_ANY_CONTIGUOUS | PyBUF_FORMAT)
            release_buff = 1
            if err == -1:
                PyBuffer_Release(&pybuffer)
                raise ValueError("Data to set is not a contigous block of memory.")
            if pybuffer.format:
                if check_buffer_format(pybuffer.format, &c_type):
                    sz = pybuffer.itemsize
                    if count_from_buf:
                        count = pybuffer.len // pybuffer.itemsize
                    else:
                        count = stp_sequence_get_size(s)
                        if (pybuffer.len // pybuffer.itemsize) < count:
                            raise ValueError("Data to set is too short.")
                    if c_type[0] == 'u':
                        if sz == sizeof(unsigned short):
                            err_code = stp_sequence_set_ushort_data(s, \
                            count, <unsigned short*> pybuffer.buf)
                        elif sz == sizeof(unsigned int):
                            err_code = stp_sequence_set_uint_data(s, \
                            count, <unsigned int*> pybuffer.buf)
                        elif sz == sizeof(unsigned long):
                            err_code = stp_sequence_set_ulong_data(s, \
                            count, <unsigned long*> pybuffer.buf)
                    elif c_type[0] == 'i':
                        if sz == sizeof(short):
                            err_code = stp_sequence_set_short_data(s, \
                            count, <short*> pybuffer.buf)
                        elif sz == sizeof(int):
                            err_code = stp_sequence_set_int_data(s, \
                            count, <int*> pybuffer.buf)
                        elif sz == sizeof(long):
                            err_code = stp_sequence_set_long_data(s, \
                            count, <long*> pybuffer.buf)
                    elif c_type[0] == 'f':
                        if sz == sizeof(float):
                            err_code = stp_sequence_set_float_data(s, \
                            count, <float*> pybuffer.buf)
                        elif sz == sizeof(double):
                            err_code = stp_sequence_set_data(s, \
                            count, <double*> pybuffer.buf)
                    if err_code == 0:
                        PyBuffer_Release(&pybuffer)
                        raise SequenceBoundsError("Attempt to set value out of bounds ")
                else:
                    err_code = 0
            else:
                err_code = 0
        else:
            err_code = 0

        if release_buff:
            PyBuffer_Release(&pybuffer)
        if not err_code:
            raise ValueError("Invalid buffer format.")

    def __richcmp__(x,  y, int comp):
        if comp != 2: # __eq__
            raise NotImplementedError()
        if not(isinstance(x, Sequence) and isinstance(y, Sequence)):
            return False
        cdef int i
        cdef stp_sequence_t *xs, *ys
        cdef double xs_v, ys_v
        cdef Sequence _x, _y
        _x = <Sequence> x
        _y = <Sequence> y
        if x.shape == y.shape:
            xs = _x.get_sequence()
            ys = _y.get_sequence()
            for i in xrange(x.size):
                stp_sequence_get_point(xs, i, &xs_v)
                stp_sequence_get_point(ys, i, &ys_v)
                if xs_v != ys_v:
                    return False
            return True
        else:
            return False


cdef bint check_buffer_format(bytes format, char** c_type):
    cdef Py_ssize_t blen, i
    cdef char *fmt_c
    cdef char fmt
    cdef bint digit

    blen = len(format)
    fmt_c = <char *> malloc(sizeof(Py_ssize_t) * (blen + 1))
    if not fmt_c:
        free(fmt_c)
        return 0
    fmt_c = format

    with nogil:
        fmt_c[blen] = 0
        i = 0
        if fmt_c[i] == '@' or fmt_c[i] == '=' or \
           fmt_c[i] == '<' or fmt_c[i] == '>' or \
           fmt_c[i] == '!' :
            i += 1
        fmt = 0
        digit = 0
        while i < blen:
            if fmt_c[i] == '1':
                if digit:
                    break
                else:
                    i += 1
                    digit = 1
                    continue
            if fmt_c[i] >= 48 and fmt_c[i] <= 39: #number 0-9
                break
            else:
                fmt = fmt_c[i]
                i += 1
                break

        if fmt != 0 and i == blen: # no complex format code
            if fmt == 'h' or fmt == 'i' or fmt == 'l' or fmt == 'q':
                c_type[0] = 'i' # signed integer
                return 1
            if fmt == 'H' or fmt == 'I' or fmt == 'L' or fmt == 'Q':
                c_type[0] = 'u' # unsigned interger
                return 1
            if fmt  == 'f' or fmt == 'd':
                c_type[0] = 'f' # float
                return 1
    return 0

@cython.final
cdef class __AuxBufferInterface:
    def __init__(__AuxBufferInterface self, Sequence obj):
        self.buffer = NULL
        self.obj = obj

    cdef set_buffer(__AuxBufferInterface self, bint readonly, void* buf, \
                    Py_ssize_t count, bytes dtype, Py_ssize_t itemsize, int ndim,
                    Py_ssize_t *shape):
        cdef int i
        self.readonly = readonly
        self.buffer = buf
        self.count = count
        self.dtype = dtype
        self.itemsize = itemsize
        self.ndim = ndim
        for i in range(ndim):
            self.shape[i] = shape[i]

    def __getbuffer__(__AuxBufferInterface self, Py_buffer *info, int flags):
        cdef int i
        if self.buffer == NULL:
            raise BufferError("")
        info.buf = self.buffer
        info.len = self.count * self.itemsize
        info.readonly = self.readonly
        info.ndim = self.ndim
        info.format = self.dtype
        info.shape = self.shape
        stride = self.itemsize
        for i in range(self.ndim - 1, -1, -1):
            self.strides[i] = stride
            stride *= self.shape[i]
        info.strides = self.strides
        info.suboffsets = NULL  # we are always direct memory buffer
        info.itemsize = self.itemsize
        info.obj = self.obj
        info.internal = NULL

        if flags & PyBUF_WRITABLE:
            if self.readonly:
                raise BufferError("Can only create a buffer that is readonly.")

        if flags & PyBUF_SIMPLE:
            # The format of data is assumed to be
            # raw unsigned bytes, without any particular structure,
            # interpreted as one dimentional array (strides=NULL)
            # The buffer exposes a read-only memory area.
            # Data is always contigous.
            info.shape = NULL
            info.strides = NULL
            info.format = NULL  # mean 'B', unsigned byte
            # The 'itemsize' field may be wrong
            return

        if not (flags & PyBUF_ND):
            info.shape = NULL

        if not (flags & PyBUF_ANY_CONTIGUOUS):
            raise BufferError("Can only create a buffer that is c contiguous in memory.")


cdef int raise_bound_error(char* message, double x, double y) except -1 with gil:
    raise SequenceBoundsError(message.decode('ascii') % (x, y))

cdef int raise_index_error(char* message, int a) except -1 with gil:
            raise IndexError(message.decode('ascii') %a)

cdef int raise_nan_error(char* message) except -1 with gil:
            raise SequenceNaNError(message.decode('ascii'))


cdef object is_slice(obj):
    cdef cython.view.memoryview mv
    try:
        flags = PyBUF_ANY_CONTIGUOUS|PyBUF_FORMAT
        mv = cython.view.memoryview(obj, flags, False)
        obj = mv
    except TypeError:
        return None
    return obj
