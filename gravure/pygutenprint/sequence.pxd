# -*- coding: utf-8 -*-

# $Id: $
# sequence.pxd
# pxd Cython C declarations for module pygutenprint.sequence
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


cdef extern from "gutenprint/sequence.h":

    struct stp_sequence:
        pass
    # The sequence opaque data type. 
    ctypedef stp_sequence stp_sequence_t
    
    # extern stp_sequence_t *stp_sequence_create(void);
    stp_sequence_t* stp_sequence_create()

    # extern void stp_sequence_destroy(stp_sequence_t *sequence);
    void stp_sequence_destroy(stp_sequence_t* sequence)

    # extern void stp_sequence_copy(stp_sequence_t *dest, const stp_sequence_t *source);
    void stp_sequence_copy(stp_sequence_t* dest, stp_sequence_t* source)

    # extern stp_sequence_t *stp_sequence_create_copy(const stp_sequence_t *sequence);
    stp_sequence_t* stp_sequence_create_copy(stp_sequence_t* sequence)
    
    # extern void stp_sequence_reverse(stp_sequence_t *dest, const stp_sequence_t *source);
    void stp_sequence_reverse(stp_sequence_t* dest, stp_sequence_t* source)
    
    # extern stp_sequence_t *stp_sequence_create_reverse(const stp_sequence_t *sequence);
    stp_sequence_t* stp_sequence_create_reverse(stp_sequence_t* sequence)

    # extern int stp_sequence_set_bounds(stp_sequence_t *sequence, double low, double high);
    bint stp_sequence_set_bounds(stp_sequence_t* sequence, double low, double high)

    # extern void stp_sequence_get_bounds(const stp_sequence_t *sequence, double *low, double *high);
    void stp_sequence_get_bounds(stp_sequence_t* sequence, double* low, double* high)
    
    # extern void stp_sequence_get_range(const stp_sequence_t *sequence, double *low, double *high);
    void stp_sequence_get_range(stp_sequence_t* sequence, double* low, double* high)

    # extern int stp_sequence_set_size(stp_sequence_t *sequence, size_t size);
    bint stp_sequence_set_size(stp_sequence_t* sequence, size_t size)   

    # extern size_t stp_sequence_get_size(const stp_sequence_t *sequence);
    size_t stp_sequence_get_size(stp_sequence_t* sequence)
    
    # extern int stp_sequence_set_data(stp_sequence_t *sequence, size_t count, const double *data);
    bint stp_sequence_set_data(stp_sequence_t* sequence, size_t count, double* data)

    # extern int stp_sequence_set_subrange(stp_sequence_t *sequence, size_t where, size_t size, const double *data);
    

    # extern void stp_sequence_get_data(const stp_sequence_t *sequence, size_t *size, const double **data);
    void stp_sequence_get_data(stp_sequence_t* sequence, size_t* size, double** data)

    # extern int stp_sequence_set_point(stp_sequence_t *sequence, size_t where, double data);
    bint stp_sequence_set_point(stp_sequence_t* sequence, size_t where, double data)
    
    # extern int stp_sequence_get_point(const stp_sequence_t *sequence, size_t where, double *data);
    bint stp_sequence_get_point(stp_sequence_t* sequence, size_t where, double* data)
    
    # extern int stp_sequence_set_float_data(stp_sequence_t *sequence, size_t count, const float *data);
    bint stp_sequence_set_float_data(stp_sequence_t* sequence, size_t count, float* data)

    # extern int stp_sequence_set_long_data(stp_sequence_t *sequence, size_t count, const long *data);
    bint stp_sequence_set_long_data(stp_sequence_t* sequence, size_t count, long* data)

    # extern int stp_sequence_set_ulong_data(stp_sequence_t *sequence, size_t count, const unsigned long *data);
    bint stp_sequence_set_ulong_data(stp_sequence_t* sequence, size_t count, unsigned long* data)

    # extern int stp_sequence_set_int_data(stp_sequence_t *sequence, size_t count, const int *data);
    bint stp_sequence_set_int_data(stp_sequence_t* sequence, size_t count, int* data)

    # extern int stp_sequence_set_uint_data(stp_sequence_t *sequence, size_t count, const unsigned int *data);
    bint stp_sequence_set_uint_data(stp_sequence_t* sequence, size_t count, unsigned int* data)

    # extern int stp_sequence_set_short_data(stp_sequence_t *sequence, size_t count, const short *data);
    bint stp_sequence_set_short_data(stp_sequence_t* sequence, size_t count, short* data)

    # extern int stp_sequence_set_ushort_data(stp_sequence_t *sequence, size_t count, const unsigned short *data);
    bint stp_sequence_set_ushort_data(stp_sequence_t* sequence, size_t count, unsigned short* data)

    # extern const float *stp_sequence_get_float_data(const stp_sequence_t *sequence, size_t *count);
    

    # extern const long *stp_sequence_get_long_data(const stp_sequence_t *sequence, size_t *count);
    

    # extern const unsigned long *stp_sequence_get_ulong_data(const stp_sequence_t *sequence, size_t *count);
    
    
    # extern const int *stp_sequence_get_int_data(const stp_sequence_t *sequence, size_t *count);
    
    
    # extern const unsigned int *stp_sequence_get_uint_data(const stp_sequence_t *sequence, size_t *count);
    

    # extern const short *stp_sequence_get_short_data(const stp_sequence_t *sequence, size_t *count);
    

    # extern const unsigned short *stp_sequence_get_ushort_data(const stp_sequence_t *sequence, size_t *count);


#===============================================================================
# Python extension type that warp the c stp_sequence_t struct
#===============================================================================
#cdef class Sequence:
#    cdef stp_sequence_t* _sequence



