# -*- coding: utf-8 -*-

# $Id: $
# curve.pxd
# pxd Cython C declarations for module pygutenprint.curve
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

#include <stdio.h>
from standardlib cimport FILE

#include <stdlib.h>

#include <gutenprint/sequence.h>
from sequence cimport stp_sequence_t



cdef extern from "gutenprint/curve.h":

    # The curve opaque data type. 
    struct stp_curve: 
        pass
    ctypedef stp_curve stp_curve_t  
      
    # Curve types. 
    ctypedef enum stp_curve_type_t:
        # Linear interpolation.
        STP_CURVE_TYPE_LINEAR
        # Spline interpolation.
        STP_CURVE_TYPE_SPLINE

    # Wrapping mode.
    ctypedef enum stp_curve_wrap_mode_t:
        #The curve does not wrap
        STP_CURVE_WRAP_NONE
        # The curve wraps to its starting point.
        STP_CURVE_WRAP_AROUND

    # Composition types.
    ctypedef enum stp_curve_compose_t:
        # Add composition.
        STP_CURVE_COMPOSE_ADD
        # Multiply composition.
        STP_CURVE_COMPOSE_MULTIPLY
        # Exponentiate composition.
        STP_CURVE_COMPOSE_EXPONENTIATE

    # Behaviour when curve exceeds bounds.
    ctypedef enum stp_curve_bounds_t:
        # Rescale the bounds.
        STP_CURVE_BOUNDS_RESCALE
        # Clip the curve to the existing bounds.
        STP_CURVE_BOUNDS_CLIP
        # Error if bounds are violated.
        STP_CURVE_BOUNDS_ERROR
    
    # Point (x,y) for piecewise curve.
    ctypedef struct stp_curve_point_t:
        # Horizontal position.
        double x
        # Vertical position.
        double y
        
    # extern stp_curve_t *stp_curve_create(stp_curve_wrap_mode_t wrap);
    stp_curve_t* stp_curve_create(stp_curve_wrap_mode_t wrap)
    
    # extern stp_curve_t *stp_curve_create_copy(const stp_curve_t *curve);
    stp_curve_t* stp_curve_create_copy(stp_curve_t* curve)
    
    # extern void stp_curve_copy(stp_curve_t *dest, const stp_curve_t *source);
    void stp_curve_copy(stp_curve_t* dest, stp_curve_t* source)
    
    # extern stp_curve_t *stp_curve_create_reverse(const stp_curve_t *curve);
    stp_curve_t* stp_curve_create_reverse(stp_curve_t* curve)

    # extern void stp_curve_reverse(stp_curve_t *dest, const stp_curve_t *source);
    void stp_curve_reverse(stp_curve_t* dest, stp_curve_t* source)
    
    # extern void stp_curve_destroy(stp_curve_t *curve);
    void stp_curve_destroy(stp_curve_t* curve)
    
    # extern int stp_curve_set_bounds(stp_curve_t *curve, double low, double high);
    bint stp_curve_set_bounds(stp_curve_t* curve, double low, double high)
    
    # extern void stp_curve_get_bounds(const stp_curve_t *curve, double *low, double *high);
    void stp_curve_get_bounds(stp_curve_t* curve, double* low, double* high)

    # extern stp_curve_wrap_mode_t stp_curve_get_wrap(const stp_curve_t *curve);
    stp_curve_wrap_mode_t stp_curve_get_wrap(stp_curve_t* curve)
    
    # extern int stp_curve_is_piecewise(const stp_curve_t *curve);
    bint stp_curve_is_piecewise(stp_curve_t* curve)

    # extern void stp_curve_get_range(const stp_curve_t *curve, double *low, double *high);
    void stp_curve_get_range(stp_curve_t* curve, double* low, double* high)
    
    # extern size_t stp_curve_count_points(const stp_curve_t *curve);
    size_t stp_curve_count_points(stp_curve_t* curve)
    
    # extern int stp_curve_set_interpolation_type(stp_curve_t *curve, stp_curve_type_t itype);
    bint stp_curve_set_interpolation_type(stp_curve_t* curve, stp_curve_type_t itype)
    
    # extern stp_curve_type_t stp_curve_get_interpolation_type(const stp_curve_t *curve);
    stp_curve_type_t stp_curve_get_interpolation_type(stp_curve_t* curve)
    
    # extern int stp_curve_set_data(stp_curve_t *curve, size_t count, const double *data);
    bint stp_curve_set_data(stp_curve_t* curve, size_t count, double* data)
    
    # extern int stp_curve_set_data_points(stp_curve_t *curve, size_t count, const stp_curve_point_t *data);
    bint stp_curve_set_data_points(stp_curve_t* curve, size_t count, stp_curve_point_t* data)
    
    # extern int stp_curve_set_ulong_data(stp_curve_t *curve, size_t count, const unsigned long *data);
    bint stp_curve_set_ulong_data(stp_curve_t* curve, size_t count, unsigned long* data)
    
    # extern int stp_curve_set_int_data(stp_curve_t *curve, size_t count, const int *data);
    bint stp_curve_set_int_data(stp_curve_t* curve, size_t count, int* data)
    
    # extern int stp_curve_set_uint_data(stp_curve_t *curve, size_t count, const unsigned int *data);
    bint stp_curve_set_uint_data(stp_curve_t* curve, size_t count, unsigned int* data)
    
    # extern int stp_curve_set_short_data(stp_curve_t *curve, size_t count, const short *data);
    bint stp_curve_set_short_data(stp_curve_t* curve, size_t count, short* data)
    
    # extern int stp_curve_set_ushort_data(stp_curve_t *curve, size_t count, const unsigned short *data);
    bint stp_curve_set_ushort_data(stp_curve_t* curve, size_t count, unsigned short* data)
    
    # extern stp_curve_t *stp_curve_get_subrange(const stp_curve_t *curve, size_t start, size_t count);
    stp_curve_t* stp_curve_get_subrange(stp_curve_t* curve, size_t start, size_t count)
    
    # extern int stp_curve_set_subrange(stp_curve_t *curve, const stp_curve_t *range, size_t start);
    bint stp_curve_set_subrange(stp_curve_t* curve, stp_curve_t* range, size_t start)
    
    # extern const double *stp_curve_get_data(const stp_curve_t *curve, size_t *count);
    double* stp_curve_get_data(stp_curve_t* curve, size_t* count)
    
    # extern const stp_curve_point_t *stp_curve_get_data_points(const stp_curve_t *curve, size_t *count);
    stp_curve_point_t* stp_curve_get_data_points(stp_curve_t* curve, size_t* count)

    # extern const float *stp_curve_get_float_data(const stp_curve_t *curve, size_t *count);
    float* stp_curve_get_float_data(stp_curve_t* curve, size_t* count)
    
    # extern const long *stp_curve_get_long_data(const stp_curve_t *curve, size_t *count);
    long* stp_curve_get_long_data(stp_curve_t* curve, size_t* count)

    # extern const unsigned long *stp_curve_get_ulong_data(const stp_curve_t *curve, size_t *count);
    unsigned long* stp_curve_get_ulong_data(stp_curve_t* curve, size_t* count)
    
    # extern const int *stp_curve_get_int_data(const stp_curve_t *curve, size_t *count);
    int* stp_curve_get_int_data(stp_curve_t* curve, size_t* count)
    
    # extern const unsigned int *stp_curve_get_uint_data(const stp_curve_t *curve, size_t *count);
    unsigned int* stp_curve_get_uint_data(stp_curve_t* curve, size_t* count)

    # extern const short *stp_curve_get_short_data(const stp_curve_t *curve, size_t *count);
    short* stp_curve_get_short_data(stp_curve_t* curve, size_t* count)

    # extern const unsigned short *stp_curve_get_ushort_data(const stp_curve_t *curve, size_t *count);
    unsigned short* stp_curve_get_ushort_data(stp_curve_t* curve, size_t* count)
    
    # extern const stp_sequence_t *stp_curve_get_sequence(const stp_curve_t *curve);
    stp_sequence_t* stp_curve_get_sequence(stp_curve_t* curve)
    
    # extern int stp_curve_set_gamma(stp_curve_t *curve, double f_gamma);
    bint stp_curve_set_gamma(stp_curve_t* curve, double f_gamma)
    
    # extern double stp_curve_get_gamma(const stp_curve_t *curve);
    double stp_curve_get_gamma(stp_curve_t* curve)
    
    # extern int stp_curve_set_point(stp_curve_t *curve, size_t where, double data);
    bint stp_curve_set_point(stp_curve_t* curve, size_t where, double data)

    # extern int stp_curve_get_point(const stp_curve_t *curve, size_t where, double *data);
    bint stp_curve_get_point(stp_curve_t* curve, size_t where, double* data)
    
    # extern int stp_curve_interpolate_value(const stp_curve_t *curve, double where, double *result);
    bint stp_curve_interpolate_value(stp_curve_t* curve, double where, double* result)
    
    # extern int stp_curve_resample(stp_curve_t *curve, size_t points);
    bint stp_curve_resample(stp_curve_t* curve, size_t points)
    
    # extern int stp_curve_rescale(stp_curve_t *curve, double scale,
    #             stp_curve_compose_t mode, stp_curve_bounds_t bounds_mode);
    bint stp_curve_rescale(stp_curve_t* curve, double scale, stp_curve_compose_t mode, stp_curve_bounds_t bounds_mode)
    
    # extern int stp_curve_write(FILE *file, const stp_curve_t *curve);
    bint stp_curve_write(FILE* file, stp_curve_t* curve)
    
    # extern char *stp_curve_write_string(const stp_curve_t *curve);
    char* stp_curve_write_string(stp_curve_t* curve)

    # extern stp_curve_t *stp_curve_create_from_stream(FILE* fp);
    stp_curve_t* stp_curve_create_from_stream(FILE* fp)
    
    # extern stp_curve_t *stp_curve_create_from_file(const char* file);
    stp_curve_t* stp_curve_create_from_file(char* file)
    
    # extern stp_curve_t *stp_curve_create_from_string(const char* string);
    stp_curve_t* stp_curve_create_from_string(char* string)

    # extern int stp_curve_compose(stp_curve_t **retval,
    #             stp_curve_t *a, stp_curve_t *b, stp_curve_compose_t mode, int points);
    bint stp_curve_compose(stp_curve_t** retval, stp_curve_t* a, stp_curve_t* b, \
                           stp_curve_compose_t mode, int points)
    
    



