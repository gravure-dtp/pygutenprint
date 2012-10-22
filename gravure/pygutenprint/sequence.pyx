# -*- coding: utf-8 -*-

# $Id: $
# sequence.pyx
# Cython module pygutenprint.sequence
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
"""Module pygutenprint.sequence.

Sequence functions.
Curve code borrowed from GTK+, http://www.gtk.org/
"""

__author__ = "Gilles Coissac <gilles@atelierobscur.org>"
__date__ = "4 May 2010"
__version__ = "$Revision: 0.1 $"
__credits__ = "Atelier Obscur : www.atelierobscur.org"


cimport python_exc
from python cimport * 
from python_buffer cimport *

import array
cimport array_API  # array_API.pxd / arrayarray.h



cdef class Sequence
cdef class SequenceIterator

#===============================================================================
# sequence Exceptions Class
#===============================================================================
class SequenceBoundsError(StandardError):
    pass

class SequenceIndexError(IndexError):
    pass

class SequenceNaNError(StandardError):
    pass

class SequenceTypeError(TypeError):
    pass

#===============================================================================
# The Sequence Iterator
#===============================================================================
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
            raise StandardError('Can\'t iterate NULL data')
    
          
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
            raise StandardError('Can\'t iterate NULL data')
        elif (self.index >= self.length or self.index < 0):
            raise StopIteration()
            
        cdef double data
        cdef bint bool_retcode 
        bool_retcode = stp_sequence_get_point(_s, self.index, &data)
        if not bool_retcode:
            raise StandardError('Abnormal Stop Iteration...')
        self.index += self.direction
        return data
          

#===============================================================================
#
# Sequence : Python extension type warping the c stp_sequence_t struct
#
#===============================================================================
cdef class Sequence:
    """The Sequence is a simple "vector of numbers" data structure.
    """
    cdef stp_sequence_t* _sequence 
    
    
    #TODO: Accept like Python list iterable argument :  
    # list, array (with its different ctype), numpy-array...   
    def __cinit__(self):
        """Create a new Sequence.

        returns the newly created Sequence.
        The Sequence is empty.
        """
        self._sequence = stp_sequence_create()
        if self._sequence is NULL:
            python_exc.PyErr_NoMemory()

    
    def __dealloc__(self):
        """Destroy a sequence.

        It is an error to destroy the sequence more than once.
        """
        if self._sequence is not NULL:
            stp_sequence_destroy(self._sequence)
    
    #===========================================================================
    # 
    # Specials Python methods usefull to implements
    # 
    #===========================================================================
    # Sequences methods
    def __iter__(self):
        """Return: iterator for sequence.
        """
        return SequenceIterator(self)
    
    
    def __reversed__(self):
        """Return: iterator in reverse order for sequence.
        """
        return SequenceIterator(self, reverse=True)
  
    
    def __contains__(self, double item):
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
                
    
    def __len__(self):
        """len(self).
        
        Get the sequence size.
        
        Return: the sequence size.
        """
        return <Py_ssize_t> stp_sequence_get_size(self._sequence)
    
    
    #TODO: negative index, slicing    
    def __setitem__(self, Py_ssize_t index, double value): 
        """self[index] = value.
        
        Set the data at a single point in a Sequence.
           
        param: index, position in Sequence (from zero).
        param: value, the datum to set.
        Raise: SequenceIndexError, SequenceBoundsError, SequenceNaNError.
        """
        # 3 errors could occurs : - index error
        #                         - data not isFinite
        #                         - data is out of bounds
        bool_retcode = stp_sequence_set_point(self._sequence, <size_t> index, value)
        # error casting
        cdef double low, high
        cdef size_t last_index
        
        if not bool_retcode:
            last_index = stp_sequence_get_size(self._sequence) - 1
            stp_sequence_get_bounds(self._sequence, &low, &high)
            if (value < low or value > high):
                raise SequenceBoundsError('Attempt to set value out of bounds (%f, %f)' %(low, high))
            elif (index>last_index or last_index<0):
                raise SequenceIndexError('[%d], Sequence index out of range' %index)
            else: 
                raise SequenceNaNError('Sequence value is not a finite number')
            

#    def __getitem__(self, Py_ssize_t index): #TODO: index peut-il etre negatif?
#        """self[index].
#        
#        Get the data at a single point in a Sequence.
#        
#        param: index, position in Sequence (from zero).
#        Raise: SequenceIndexError.
#        Return: a Python float value.
#        """
#        cdef double data
#        bool_retcode = stp_sequence_get_point(self._sequence, <size_t> index, &data)
#        if not bool_retcode:
#            raise SequenceIndexError('[%d], Sequence index out of range' %index)
#        return data
    
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
    
        
    def __delitem__(self, index):
        """NotImplemented.
        """
        raise NotImplementedError('Sequence doesn\'t support removal of elements')
        
    
    # General
    def __comp__(x, y):
        """3-way comparison.
        
        Return: an integer value.
        """
        raise NotImplementedError
    
    
    def __str__(self):
        """Get the String representation of the Sequence.
        
        str(Sequence) return the same as repr(sequence)
        
        Return: a string
        """
        return self.__repr__()
    
    #TODO: with eval(repr(sequence)), should recreate
    # a valid Sequence equal to sequence
    def __repr__(self):
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
        
    #===========================================================================
    # 
    # Other Python methods 
    # 
    #===========================================================================
    
    def reset_size(self, Py_ssize_t size):
        """Reset the sequence size.
        
        The size is the number of elements the sequence contains.  
        Note! : that resizing will destroy all data contained 
        in the sequence.
        
        param: size, the size to set the sequence to.
        
        raise: MemmoryException.
        """
        bool_retcode = stp_sequence_set_size(self._sequence, <size_t> size)
        if not bool_retcode:
            python_exc.PyErr_NoMemory()
            
            
    def copy_in(self, Sequence dest not None):
        """Copy this Sequence in dest.
        
        dest must be a valid Sequence previously instancied
        with dest = Sequence().
        
        param: dest the destination Sequence.
        """
        stp_sequence_copy(dest._sequence, self._sequence)
        #TODO: could stp_abort() happend here? --> python_exc.PyErr_NoMemory()        


    def copy(self):
        """Return a copy of this Sequence.
        
        A new sequence will be created, and then the contents 
        of self will be copied into it.  
                
        @returns the new copy of the Sequence.
        """
        cdef Sequence copy_sequence  # need to be typed to access '_sequence' c struct
        copy_sequence = Sequence()
        stp_sequence_copy(copy_sequence._sequence, self._sequence)
        #TODO: could stp_abort() happend here? --> python_exc.PyErr_NoMemory()        
        
        return copy_sequence

        
    def reverse(self):
        """NotImplemented! Reverse the sequence in place.
           
        Note : this is a different behavior to the c implementation function.
        The c function stp_reverse() copy the reversed data in a destination 
        structure without touching the source. The c api doesn't provide 
        in place function.
        """
        #cdef stp_sequence_t* seq_dest
        #seq_dest = stp_sequence_create()
        #stp_sequence_reverse(seq_dest, self._sequence)
        raise NotImplementedError

    
    def create_reverse(self): 
        """Return a reversed copy.
        
        A new Sequence will be returned with the reverse contents 
        of self being copied into it.  
         
        returns: the new copy of the Sequence.
        """
        cdef Sequence reverse_sequence  # need to be typed to access '_sequence' c struct
        reverse_sequence = Sequence()
        stp_sequence_reverse(reverse_sequence._sequence, self._sequence)
        #TODO: could stp_abort() happend here? --> python_exc.PyErr_NoMemory()
        
        return reverse_sequence
    
        
    def set_bounds(self, double min, double max):
        """Set the lower and upper bounds.
        
        The lower and upper bounds set the minimum and maximum values
        that a point in the sequence may hold.
        
        param: the float min value for the lower bound.
        param: the float max value for the upper bound.
        
        raise: SequenceBoundsError if the lower bound is greater than
        the upper bound.
        """
        bool_retcode = stp_sequence_set_bounds(self._sequence, min, max)
        if not bool_retcode:
            raise SequenceBoundsError('the lower bound is greater than the upper bound :\n\tmin: %f, max: %f' %(min, max))
        
        
    def get_bounds(self):
        """Get the lower and upper bounds.
        
        return: a tuple of the float bounds values, (min, max).
        """
        cdef double min, max
        stp_sequence_get_bounds(self._sequence, &min, &max)
        return min, max

        
    def get_range(self):
        """Get range of values stored in the sequence.
        
        Return: a tuple of the float values (min, max).
        """
        cdef double low, high
        stp_sequence_get_range(self._sequence, &low, &high)
        return low, high
    
    
    def min(self):
        """Get the min value stored in the sequence.
        
        Return: the float the low bound.
        """
        cdef double low, high
        stp_sequence_get_range(self._sequence, &low, &high)
        return low
    
    
    def max(self):
        """Get the max value stored in the sequence.
        
        Return: the float the high bound.
        """
        cdef double low, high
        stp_sequence_get_range(self._sequence, &low, &high)
        return high
    
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
    
    #TODO: Implementing get_float, get_long, get_int, etc.. 
    #with method returning Python Array with had'oc type (or buffer)
    def get_data(self, typecode=None):
        """Get the data in a sequence.
           
        @param sequence the sequence to get the data from.
        @param size the number of elements in the sequence are stored in
        the size_t pointed to.
        @param data a pointer to the first element of a sequence of doubles
        is stored in a pointer to double*.
        
        @code
        stp_sequence_t *sequence;
        size_t size;
        double *data;
        stp_sequence_get_data(sequence, &size, &data);
        @endcode
        """
        cdef double* data
        cdef size_t size
        
        # here, gcc complain with '&data' is not a <const>,
        # but it will not be a problem, isn't it?
        stp_sequence_get_data(self._sequence, &size, &data)
        return None


    #WARNING: here use a fake Python API (array_API)
    # to access the c fields of Python array.array
    # This is a ticket on cython trac, it's should
    # be part of a further cython version.
    # http://trac.cython.org/cython_trac/ticket/314
    def set_data(self, array_API.array arr not None):    
        """Set the data in a sequence.
        
        
        
        Param: data a Python Built-in array 
        Raise: TypeError if None or an array with a 
        not supported typed is pass.    
        """
        #TODO: make same behavior for double and other types
        cdef :
            int arr_typecode = arr.ob_descr.typecode
            Py_ssize_t count = <Py_ssize_t> arr.length
            bint bool_retcode
        
        if (arr.typecode == 'd'):
            bool_retcode = stp_sequence_set_data(self._sequence, <size_t> count, arr._d)
        elif (arr.typecode == 'f'):
            bool_retcode = stp_sequence_set_float_data(self._sequence, <size_t> count, arr._f)
        elif (arr.typecode == 'l'):
            bool_retcode = stp_sequence_set_long_data(self._sequence, <size_t> count, arr._l)
        elif (arr.typecode == 'L'):
            bool_retcode = stp_sequence_set_ulong_data(self._sequence, <size_t> count, arr._L)
        elif (arr.typecode == 'i'):
            bool_retcode = stp_sequence_set_int_data(self._sequence, <size_t> count, arr._i)
        elif (arr.typecode == 'I'):
            bool_retcode = stp_sequence_set_uint_data(self._sequence, <size_t> count, arr._I)
        elif (arr.typecode == 'h'):
            bool_retcode = stp_sequence_set_short_data(self._sequence, <size_t> count, arr._h)
        elif (arr.typecode == 'H'):
            bool_retcode = stp_sequence_set_ushort_data(self._sequence, <size_t> count, arr._H)
        else :
            bad_type = {'c':'char', 'b':'signed char', 'B':'unsigned car', 'u':'PY_UNICODE'}.get(arr.typecode)      
            raise TypeError('Wrong array type : Sequence should\'nt be set with %s data' %bad_type)

        if not bool_retcode:
            raise StandardError('ca merde')


    def set_subrange(self, array_API.array arr not None, Py_ssize_t index):
        """Set the data in a subrange of a sequence.
        
        @param sequence the sequence to set.
        @param where the starting element in the sequence (indexed from
        0).
        @param size the number of elements in the data.
        @param data a pointer to the first member of a sequence
        containing the data to set.
        
        @returns 1 on success, 0 on failure.
        """
        cdef :
            int arr_typecode = arr.ob_descr.typecode
            Py_ssize_t count = <Py_ssize_t> arr.length
            bint bool_retcode
        
        

        


