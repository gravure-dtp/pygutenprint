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

"""Module pygutenprint.sequence.

Sequence functions.
Curve code borrowed from GTK+, http://www.gtk.org/
"""

import cython
cimport cython

import array

cdef extern from "Python.h":
    bint PyIndex_Check(object o)
    # Returns True if o is an index integer (has the nb_index slot of
    # the tp_as_number structure filled in).

    bint PyObject_CheckBuffer(object obj)
    # Return 1 if obj supports the buffer interface otherwise 0.

    int PyObject_GetBuffer(object obj, Py_buffer *view, int flags) except -1

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
    # extern stp_sequence_t *stp_sequence_create(void);
    stp_sequence_t* stp_sequence_create() nogil

    # extern void stp_sequence_destroy(stp_sequence_t *sequence);
    void stp_sequence_destroy(stp_sequence_t* sequence) nogil

    # extern void stp_sequence_copy(stp_sequence_t *dest, const stp_sequence_t *source);
    void stp_sequence_copy(stp_sequence_t* dest, stp_sequence_t* source) nogil

    # extern stp_sequence_t *stp_sequence_create_copy(const stp_sequence_t *sequence);
    stp_sequence_t* stp_sequence_create_copy(stp_sequence_t* sequence) nogil

    # extern void stp_sequence_reverse(stp_sequence_t *dest, const stp_sequence_t *source);
    void stp_sequence_reverse(stp_sequence_t* dest, stp_sequence_t* source) nogil

    # extern stp_sequence_t *stp_sequence_create_reverse(const stp_sequence_t *sequence);
    stp_sequence_t* stp_sequence_create_reverse(stp_sequence_t* sequence) nogil

    # extern int stp_sequence_set_bounds(stp_sequence_t *sequence, double low, double high);
    bint stp_sequence_set_bounds(stp_sequence_t* sequence, double low, double high) nogil

    # extern void stp_sequence_get_bounds(const stp_sequence_t *sequence, double *low, double *high);
    void stp_sequence_get_bounds(stp_sequence_t* sequence, double* low, double* high) nogil

    # extern void stp_sequence_get_range(const stp_sequence_t *sequence, double *low, double *high);
    void stp_sequence_get_range(stp_sequence_t* sequence, double* low, double* high) nogil

    # extern int stp_sequence_set_size(stp_sequence_t *sequence, size_t size);
    bint stp_sequence_set_size(stp_sequence_t* sequence, size_t size) nogil

    # extern size_t stp_sequence_get_size(const stp_sequence_t *sequence);
    size_t stp_sequence_get_size(stp_sequence_t* sequence) nogil

    # extern int stp_sequence_set_data(stp_sequence_t *sequence, size_t count, const double *data);
    bint stp_sequence_set_data(stp_sequence_t* sequence, size_t count, double* data) nogil

    # extern int stp_sequence_set_subrange(stp_sequence_t *sequence, size_t where, size_t size, const double *data);


    # extern void stp_sequence_get_data(const stp_sequence_t *sequence, size_t *size, const double **data);
    void stp_sequence_get_data(const stp_sequence_t* sequence, size_t* size, const double** data) nogil

    # extern int stp_sequence_set_point(stp_sequence_t *sequence, size_t where, double data);
    bint stp_sequence_set_point(stp_sequence_t* sequence, size_t where, double data) nogil

    # extern int stp_sequence_get_point(const stp_sequence_t *sequence, size_t where, double *data);
    bint stp_sequence_get_point(stp_sequence_t* sequence, size_t where, double* data) nogil

    # extern int stp_sequence_set_float_data(stp_sequence_t *sequence, size_t count, const float *data);
    bint stp_sequence_set_float_data(stp_sequence_t* sequence, size_t count, float* data) nogil

    # extern int stp_sequence_set_long_data(stp_sequence_t *sequence, size_t count, const long *data);
    bint stp_sequence_set_long_data(stp_sequence_t* sequence, size_t count, long* data) nogil

    # extern int stp_sequence_set_ulong_data(stp_sequence_t *sequence, size_t count, const unsigned long *data);
    bint stp_sequence_set_ulong_data(stp_sequence_t* sequence, size_t count, unsigned long* data) nogil

    # extern int stp_sequence_set_int_data(stp_sequence_t *sequence, size_t count, const int *data);
    bint stp_sequence_set_int_data(stp_sequence_t* sequence, size_t count, int* data) nogil

    # extern int stp_sequence_set_uint_data(stp_sequence_t *sequence, size_t count, const unsigned int *data);
    bint stp_sequence_set_uint_data(stp_sequence_t* sequence, size_t count, unsigned int* data) nogil

    # extern int stp_sequence_set_short_data(stp_sequence_t *sequence, size_t count, const short *data);
    bint stp_sequence_set_short_data(stp_sequence_t* sequence, size_t count, short* data) nogil

    # extern int stp_sequence_set_ushort_data(stp_sequence_t *sequence, size_t count, const unsigned short *data);
    bint stp_sequence_set_ushort_data(stp_sequence_t* sequence, size_t count, unsigned short* data) nogil

    # extern const float *stp_sequence_get_float_data(const stp_sequence_t *sequence, size_t *count);


    # extern const long *stp_sequence_get_long_data(const stp_sequence_t *sequence, size_t *count);


    # extern const unsigned long *stp_sequence_get_ulong_data(const stp_sequence_t *sequence, size_t *count);


    # extern const int *stp_sequence_get_int_data(const stp_sequence_t *sequence, size_t *count);


    # extern const unsigned int *stp_sequence_get_uint_data(const stp_sequence_t *sequence, size_t *count);


    # extern const short *stp_sequence_get_short_data(const stp_sequence_t *sequence, size_t *count);


    # extern const unsigned short *stp_sequence_get_ushort_data(const stp_sequence_t *sequence, size_t *count);


#
# sequence Exceptions Class
#
class SequenceBoundsError(Exception):
    pass

class SequenceIndexError(IndexError):
    pass

class SequenceNaNError(Exception):
    pass

class SequenceTypeError(TypeError):
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


cpdef test_data():
    cdef stp_sequence_t* _sequence
    cdef double* data_test
    cdef double* data_test_b
    cdef double [15] data_in
    cdef int i
    cdef bint retcode
    cdef size_t ret_size

    for i in range(15):
        data_in[i] = i

    _sequence = stp_sequence_create()
    stp_sequence_set_size(_sequence, <size_t> 15)
    stp_sequence_get_data(<const stp_sequence_t*> _sequence, &ret_size, <const double**> &data_test)
    print_data(data_test, 15)

    retcode = stp_sequence_set_data(_sequence, <size_t> 15, data_in)
    if not retcode:
        raise SystemError("in set_data")
    stp_sequence_get_data(<const stp_sequence_t*> _sequence, &ret_size, <const double**> &data_test)
    print_data(data_test, 15)

    data_test[10] = <double> 99.00
    print_data(data_test, 15)

    stp_sequence_get_data(<const stp_sequence_t*> _sequence, &ret_size, <const double**> &data_test_b)
    print_data(data_test_b, 15)


cdef print_data(double* data, size_t size):
    cdef int i
    list_d = []
    for i in range(size):
        list_d.append(data[i])
    print "data : " + list_d.__str__()


#
# Sequence :
# Python extension type warping
# the c stp_sequence_t struct
#
cdef class Sequence:
    """The Sequence is a simple "vector of numbers" data structure.
    """

    #TODO: Accept like Python list iterable argument :
    # list, array (with its different ctype), numpy-array...
    def __cinit__(Sequence self):
        """Create a new Sequence.

        returns the newly created Sequence.
        The Sequence is empty.
        raise: MemmoryError.
        """
        self._sequence = stp_sequence_create()
        if not self._sequence:
            raise MemoryError("Unable to create a new sequence.")

    def __dealloc__(Sequence self):
        """Destroy a sequence.

        It is an error to destroy the sequence more than once.
        """
        if self._sequence is not NULL:
            stp_sequence_destroy(self._sequence)

    #
    # STRING REPRESENTATION
    #
    def __str__(self):
        """Get the String representation of the Sequence.

        str(Sequence) return the same as repr(sequence)

        Return: a string
        """
        return self.__repr__()

    #TODO: with eval(repr(sequence)), should recreate
    # a valid Sequence equal to sequence
    def __repr__(Sequence self):
        """Get the String representation of the Sequence.

        Return a string representing the Sequence.
        You could do : new_S = eval(repr(Sequence)),
        creating a new valid Sequence Object,
        with new_S == Sequence.

        Return: a string
        """
        cdef size_t length
        length = stp_sequence_get_size(self._sequence)

        raise NotImplementedError

    #
    # COPY METHODS
    #
    cpdef copy_in(Sequence self, Sequence dest):
        """Copy this Sequence in dest.

        dest must be a valid Sequence previously instancied
        with dest = Sequence().

        param: dest the destination Sequence.
        """
        if dest:
            stp_sequence_copy(dest._sequence, self._sequence)
        else:
            raise ValueError("The Sequence parameter is not valid")

    cpdef copy(Sequence self):
        """Return a copy of this Sequence.

        A new sequence will be created, and then the contents
        of self will be copied into it.

        returns the new copy of the Sequence.
        """
        cdef Sequence copy_sequence  # need to be typed to access '_sequence' c struct
        copy_sequence = Sequence()
        stp_sequence_copy(copy_sequence._sequence, self._sequence)
        return copy_sequence

    #
    # SIZED INTERFACE
    #
    def __len__(Sequence self):
        """len(self).

        Get the sequence size.
        """
        return <Py_ssize_t> stp_sequence_get_size(self._sequence)

    cpdef set_size(Sequence self, Py_ssize_t size):
        """Set the sequence size.

        The size is the number of elements the sequence contains.
        Note! : that resizing will destroy all data contained
        in the sequence.

        param: size, the size to set the sequence to.
        raise: MemmoryError.
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

        Return: True or False.
        """
        cdef :
            double data
            bint ret_code
            size_t index, length

        ret_code = 0
        length = stp_sequence_get_size(self._sequence)
        for index in range(length):
            stp_sequence_get_point(self._sequence, index, &data)
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
        seq_rev = stp_sequence_create_reverse(self._sequence)
        stp_sequence_destroy(self._sequence)
        self._sequence = seq_rev

    cpdef create_reverse(Sequence self):
        """Return a reversed copy.

        A new Sequence will be returned with the reverse contents
        of self being copied into it.

        returns: the new copy of the Sequence.
        """
        cdef Sequence reverse_sequence
        reverse_sequence = Sequence()
        stp_sequence_reverse(reverse_sequence._sequence, self._sequence)
        return reverse_sequence

    #
    # BOUNDARY METHODS
    #
    cpdef set_bounds(Sequence self, double cmin, double cmax):
        """Set the lower and upper bounds.

        The lower and upper bounds set the minimum and maximum values
        that a point in the sequence may hold.

        param: the float min value for the lower bound.
        param: the float max value for the upper bound.
        raise: SequenceBoundsError if the lower bound is greater than
        the upper bound.
        """
        cdef bint retcode
        retcode = stp_sequence_set_bounds(self._sequence, cmin, cmax)
        if not retcode:
            raise SequenceBoundsError('the lower bound is greater than the \
                  upper bound :\n\tmin: %f, max: %f' %(min, max))

    cpdef get_bounds(Sequence self):
        """Get the lower and upper bounds.

        return: a tuple of floats bounds values, (min, max).
        """
        cdef double cmin, cmax
        stp_sequence_get_bounds(self._sequence, &cmin, &cmax)
        return min, max

    cpdef get_range(Sequence self):
        """Get range of values stored in the sequence.

        Return: a tuple of floats values (min, max).
        """
        cdef double low, high
        stp_sequence_get_range(self._sequence, &low, &high)
        return low, high

    cpdef double min(Sequence self):
        """Get the min value stored in the sequence.

        Return: float for the low bound.
        """
        cdef double low, high
        stp_sequence_get_range(self._sequence, &low, &high)
        return low

    cpdef double max(Sequence self):
        """Get the max value stored in the sequence.

        Return: float for the high bound.
        """
        cdef double low, high
        stp_sequence_get_range(self._sequence, &low, &high)
        return high

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
                index %= self.__len__()
            self.set_point(index, value)
        else:
            raise TypeError("Cannot index with type '%s'" % type(index))

    cdef int set_slice(Sequence self, object index, object value, bint val_is_slice)except -1:
        cdef Py_ssize_t start, stop, size, i, v
        cdef cython.view.memoryview mv
        cdef Py_buffer pybuffer
        cdef double d_val

        (start, stop, step) = index.start, index.stop, index.step
        if index.step != 1 or not None:
                raise ValueError("step in slice is not implemented")
        if start < 0:
                start %= self.__len__()
        if stop < 0:
                stop %= self.__len__()
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
            for i in xrange(start, stop):
                self.set_point(i, d_val)
                v += 1

    cdef bint set_point(Sequence self, size_t index, double value)nogil except 0:
        """Set the data at a single point in a Sequence.

        param: index, position in Sequence (from zero).
        param: value, the datum to set.
        Raise: SequenceIndexError, SequenceBoundsError, SequenceNaNError.
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

    #TODO: negative index, slicing
    def __getitem__(self, index):
        """self[index].

        Get the data at a single point in a Sequence.

        Param: index, position in Sequence (from zero).
        Raise: SequenceIndexError, SequenceTypeError.
        Return: a Python float value or a new Sequence
        copied from the slice values.
        """
        cdef double data
        cdef Py_ssize_t py_index

        if (isinstance(index, slice)):
            return "slice...", index
        elif (isinstance(index, int)):
            bool_retcode = stp_sequence_get_point(self._sequence, <size_t> index, &data)
            if not bool_retcode:
                raise SequenceIndexError('[%d], Sequence index out of range' %index)
            return data
        else:
            raise SequenceTypeError('Sequence indices must be integers, not %s' %type(index).__name__)


#        """Get the data in a sequence as float data.
#
#        The pointer returned is owned by the curve, and is not guaranteed
#        to be valid beyond the next non-const curve call;
#        If the bounds of the curve exceed the limits of the data type,
#        NULL is returned.
#
#        @param sequence the sequence to get the data from.
#        @param count the number of elements in the sequence are stored in
#        the size_t pointed to.
#
#        @returns a pointer to the first element of an sequence of floats
#        is stored in a pointer to float*.
#


    def set_subrange(self, arr not None, Py_ssize_t index):
        """Set the data in a subrange of a sequence.

        @param sequence the sequence to set.
        @param where the starting element in the sequence (indexed from
        0).
        @param size the number of elements in the data.
        @param data a pointer to the first member of a sequence
        containing the data to set.

        @returns 1 on success, 0 on failure.

        cdef :
            int arr_typecode = arr.ob_descr.typecode
            Py_ssize_t count = <Py_ssize_t> arr.length
            bint bool_retcode

        """
        pass

    #
    # BUFFER INTERFACE [PEP 3118]
    #
    def __getbuffer__(Sequence self, Py_buffer *info, int flags):
        cdef size_t ret_size
        cdef double* data_buf
        cdef Py_ssize_t [1] shape
        cdef Py_ssize_t [1] strides

        stp_sequence_get_data(<const stp_sequence_t*> self._sequence, &ret_size, <const double**> &data_buf)
        shape[0] = self.__len__
        strides[0] =  sizeof(double)

        info.buf = <void*> data_buf
        info.len = self.__len__() * sizeof(double)
        info.readonly = 0
        info.ndim = 1
        info.format = b'@d'
        info.shape = shape
        info.strides = strides
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
        def __get__(self):
            # Make this a property as 'self.data' may be set after instantiation
            flags =  PyBUF_ANY_CONTIGUOUS|PyBUF_FORMAT|PyBUF_WRITABLE
            cdef cython.view.memoryview mv = cython.view.memoryview(self, flags, False)
            return mv

    def get_data(self):
        """Get acces to the data buffer for this sequence.

        Return: a Python memoryview.
        """
        return self.memview

    def set_data(self, obj not None):
        """Set the data in a sequence.

        Param: a python array like implementing the buffer interface.
        Raise: ValueError if None or with an array with a
        not supported type.
        """
        cdef Py_buffer pybuffer
        cdef char *c_type
        cdef size_t sz, count
        cdef bint err_code = 1

        if PyObject_CheckBuffer(obj):
            PyObject_GetBuffer(obj, &pybuffer, PyBUF_ND | PyBUF_FORMAT)
            if pybuffer.ndim != 1:
                PyBuffer_Release(&pybuffer)
                raise ValueError("Multidimentionnal array is not accepted.")
            if pybuffer.format:
                if check_buffer_format(pybuffer.format, &c_type):
                    sz = pybuffer.itemsize
                    count = pybuffer.shape[0]
                    if c_type[0] == 'u':
                        if sz == sizeof(unsigned short):
                            err_code = stp_sequence_set_ushort_data(self._sequence, \
                            count, <unsigned short*> pybuffer.buf)
                        if sz == sizeof(unsigned int):
                            err_code = stp_sequence_set_uint_data(self._sequence, \
                            count, <unsigned int*> pybuffer.buf)
                        if sz == sizeof(unsigned long):
                            err_code = stp_sequence_set_ulong_data(self._sequence, \
                            count, <unsigned long*> pybuffer.buf)
                    if c_type[0] == 'i':
                        if sz == sizeof(short):
                            err_code = stp_sequence_set_short_data(self._sequence, \
                            count, <short*> pybuffer.buf)
                        if sz == sizeof(int):
                            err_code = stp_sequence_set_int_data(self._sequence, \
                            count, <int*> pybuffer.buf)
                        if sz == sizeof(long):
                            err_code = stp_sequence_set_long_data(self._sequence, \
                            count, <long*> pybuffer.buf)
                    if c_type[0] == 'f':
                        if sz == sizeof(float):
                            err_code = stp_sequence_set_float_data(self._sequence, \
                            count, <float*> pybuffer.buf)
                        if sz == sizeof(double):
                            err_code = stp_sequence_set_data(self._sequence, \
                            count, <double*> pybuffer.buf)
                else:
                    err_code = 0
            else:
                err_code = 0

        PyBuffer_Release(&pybuffer)
        if not err_code:
            raise ValueError("Invalid buffer format.")


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

        if fmt != 0 and i == blen-1: # no complex format code
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

cdef int raise_bound_error(char* message, double x, double y) except -1 with gil:
    raise SequenceBoundsError(message.decode('ascii') % (x, y))

cdef int raise_index_error(char* message, int a) except -1 with gil:
            raise SequenceIndexError(message.decode('ascii') %a)

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
