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
"""Module pygutenprint.curve.

Curve functions.
Curve code borrowed from GTK+, http://www.gtk.org/
"""


#
#
#"""The curve type models a linear, spline or gamma curve.
#curve "inherits" from the sequence data structure (implemented via
#containment), since the curve data is represented internally as a
#sequence of numbers, for linear and spline curves.  Linear
#Piecewise Curves (LPCs) should be implemented in the future which
#represent a curve in a more compact format.
#
#Various operations are supported, including interpolation and
#composition.
#
#@defgroup curve curve
#@{
#"""


#"""Create a new curve.
#
#Curves have y=lower..upper. The default bounds are 0..1.
#The default interpolation type is linear.
#There are no points allocated, and the gamma is defaulted to 1.
#The curve is a dense (equally-spaced) curve.
#
#A wrapped curve has the same value at x=0 and x=1.  The wrap mode
#of a curve cannot be changed except by routines that destroy the
#old curve entirely (e. g. stp_curve_copy, stp_curve_read).
#
#@param wrap the wrap mode of the curve.
#@returns the newly created curve.
#"""


#"""Copy and allocate a curve.
#
#dest will be created, and then the contents of source will be
#copied into it.  dest must not have been previously allocated
#with stp_curve_create().
#
#@param curve the source curve.
#@returns the new copy of the curve.
#"""


#"""Copy a curve.
#
#Both dest and source must be valid curves previously
#created with stp_curve_create().
#
#@param dest the destination curve.
#@param source the source curve.
#"""


#"""Reverse and allocate a curve.
#
#dest will be created, and then the contents of source will be
#copied into it.  dest must not have been previously allocated
#with stp_curve_create().
#
#@param curve the source curve.
#@returns the new copy of the curve.
#"""


#"""Reverse a curve.
#
#Both dest and source must be valid curves previously
#created with stp_curve_create().
#
#@param dest the destination curve.
#@param source the source curve.
#"""


#"""Destroy an curve.
#
#It is an error to destroy the curve more than once.
#
#param curve the curve to destroy.
#"""


#"""Set the lower and upper bounds on a curve.
#
#To change the bounds adjusting data as required,
#use stp_curve_rescale instead.
#
#@param curve the curve to use.
#@param low the lower bound.
#@param high the upper bound.
#
#@returns FALSE if any existing points on the curve are outside the
#bounds.
#"""


#"""Get the lower and upper bounds on a curve.
#
#@param curve the curve to use.
#@param low a pointer to a double to store the lower bound in.
#@param high a pointer to a double to store the upper bound in.
#"""


#"""Get the wrapping mode.
#
#@param curve the curve to use.
#
#@returns the wrapping mode.
#"""


#"""Determine whether the curve is piecewise
#
#@param curve the curve to use.
#
#@returns whether the curve is piecewise
#"""


#"""Get the range (lowest and highest value of points) in the curve.
#
#This does not account for any interpolation that may place
#intermediate points outside of the curve.
#
#@param curve the curve to use.
#@param low a pointer to double to store the lower limit in.
#@param high a pointer to double to store the upper limit in.
#"""


#"""Get the number of allocated points in the curve.
#
#@param curve the curve to use.
#
#@returns the number of points.
#"""


#"""Set the curve interpolation type.
#
#@param curve the curve to use.
#@param itype the interpolation type.
#
#@returns 1 on success, or 0 if itype is invalid.
#"""


#"""Get the curve interpolation type.
#
#@param curve the curve to use.
#
#@returns the interpolation type.
#"""


#"""Set all data points of the curve.
#
#If any of the data points fall
#outside the bounds, the operation is not performed and FALSE is
#returned.  This creates a curve with equally-spaced points.
#
#@param curve the curve to use.
#@param count the number of points (must be at least two and not
#more than 1048576).
#@param data a pointer to an array of doubles (must be at least
#count in size).
#
#@returns 1 on success, 0 on failure.
#"""


#"""Set all data points of the curve.
#
#If any of the data points fall
#outside the bounds, the operation is not performed and FALSE is
#returned.  This creates a piecewise curve.
#
#@param curve the curve to use.
#@param count the number of points (must be at least two and not
#more than 1048576).
#@param data a pointer to an array of points (must be at least
#count in size).  The first point must have X=0, and each point must
#have an X value at least .000001 greater than the previous point.  If
#the curve is not a wraparound curve, the last point must have X=1.
#
#@returns 1 on success, 0 on failure.
#"""


#"""Set the data points in a curve from unsigned long values.
#
#If any of the data points fall outside the bounds, the operation is not
#performed and FALSE is returned.  This creates a curve with
#equally-spaced points.
#
#@param curve the curve to use.
#@param count the number of the number of points (must be at least
#two and not more than 1048576).
#@param data a pointer to an array of unsigned longs (must be at
#least count in size).
#
#@returns 1 on success, 0 on failure.
#"""


#"""Set the data points in a curve from integer values.
#
#If any of the data points fall outside the bounds,
#the operation is not performed and FALSE is returned.
#This creates a curve with equally-spaced points.
#
#@param curve the curve to use.
#@param count the number of the number of points (must be at least
#two and not more than 1048576).
#@param data a pointer to an array of integers (must be at least
#count in size).
#
#@returns 1 on success, 0 on failure.
#"""


#"""Set the data points in a curve from unsigned integer values.
#If any of the data points fall outside the bounds, the operation is
#not performed and FALSE is returned.  This creates a curve with
#equally-spaced points.
#
#@param curve the curve to use.
#@param count the number of the number of points (must be at least
#two and not more than 1048576).
#@param data a pointer to an array of unsigned integers (must be at
#least count in size).
#
#@returns 1 on success, 0 on failure.
#"""


#"""Set the data points in a curve from short values.
#
#If any of the data points fall outside the bounds, the operation is not performed
#and FALSE is returned.  This creates a curve with equally-spaced points.
#
#@param curve the curve to use.
#@param count the number of the number of points (must be at least
#two and not more than 1048576).
#@param data a pointer to an array of shorts (must be at least
#count in size).
#
#@returns 1 on success, 0 on failure.
#"""


#"""Set the data points in a curve from unsigned short values.
#
#If any of the data points fall outside the bounds, the operation is not
#performed and FALSE is returned.  This creates a curve with
#equally-spaced points.
#
#@param curve the curve to use.
#@param count the number of the number of points (must be at least
#two and not more than 1048576).
#@param data a pointer to an array of unsigned shorts (must be at
#least count in size).
#
#@returns 1 on success, 0 on failure.
#"""


#"""Get a curve containing a subrange of data.
#
#If the start or count is invalid, the returned curve will
#compare equal to NULL (i. e. it will be a null pointer).
#start and count must not exceed the
#number of points in the curve, and count must be at least 2.
#The curve must be a dense (equally-spaced) curve.
#
#@param curve the curve to use.
#@param start the start of the subrange.
#@param count the number of point starting at start.
#
#@returns a curve containing the subrange.  The returned curve is
#non-wrapping.
#"""


#"""Set part of a curve to the range in another curve.
#
#The data in the range must fit within both the bounds
#and the number of points in the first curve.
#The curve must be a dense (equally-spaced) curve.
#
#@param curve the curve to use (destination).
#@param range the source curve.
#@param start the starting point in the destination range.
#returns 1 on success, 0 on failure.
#"""


#"""Get a pointer to the curve's raw data.
#
#@param curve the curve to use.
#@param count a pointer to a size_t to store the curve size in.
#
#@returns a pointer to the curve data.  This data is not guaranteed
#to be valid beyond the next non-const curve call.  If the curve is
#a pure gamma curve (no associated points), NULL is returned and the
#count is 0.  This call also returns NULL if the curve is a piecewise
#curve.
#"""


#"""Get a pointer to the curve's raw data as points.
#
#@param curve the curve to use.
#@param count a pointer to a size_t to store the curve size in.
#
#@returns a pointer to the curve data.  This data is not guaranteed
#to be valid beyond the next non-const curve call.  If the curve is
#a pure gamma curve (no associated points), NULL is returned and the
#count is 0.  This call also returns NULL if the curve is a dense
#(equally-spaced) curve.
#"""


#"""Get pointer to the curve's raw data as floats.
#
#@param curve the curve to use.
#@param count a pointer to a size_t to store the curve size in.
#
#@returns a pointer to the curve data.  This data is not guaranteed
#to be valid beyond the next non-const curve call.  If the curve is
#a pure gamma curve (no associated points), NULL is returned and the
#count is 0.  This also returns NULL if the curve is a piecewise curve.
#"""


#"""Get pointer to the curve's raw data as longs.
#
#@param curve the curve to use.
#@param count a pointer to a size_t to store the curve size in.
#
#@returns a pointer to the curve data.  This data is not guaranteed
#to be valid beyond the next non-const curve call.  If the curve is
#a pure gamma curve (no associated points), NULL is returned and the
#count is 0.  This also returns NULL if the curve is a piecewise curve.
#"""


#"""Get pointer to the curve's raw data as unsigned longs.
#
#@param curve the curve to use.
#@param count a pointer to a size_t to store the curve size in.
#
#@returns a pointer to the curve data.  This data is not guaranteed
#to be valid beyond the next non-const curve call.  If the curve is
#a pure gamma curve (no associated points), NULL is returned and the
#count is 0.  This also returns NULL if the curve is a piecewise curve.
#"""


#"""Get pointer to the curve's raw data as integers.
#
#@param curve the curve to use.
#@param count a pointer to a size_t to store the curve size in.
#
#@returns a pointer to the curve data.  This data is not guaranteed
#to be valid beyond the next non-const curve call.  If the curve is
#a pure gamma curve (no associated points), NULL is returned and the
#count is 0.  This also returns NULL if the curve is a piecewise curve.
#"""


#"""Get pointer to the curve's raw data as unsigned integers.
#
#@param curve the curve to use.
#@param count a pointer to a size_t to store the curve size in.
#
#@returns a pointer to the curve data.  This data is not guaranteed
#to be valid beyond the next non-const curve call.  If the curve is
#a pure gamma curve (no associated points), NULL is returned and the
#count is 0.  This also returns NULL if the curve is a piecewise curve.
#"""


#"""Get pointer to the curve's raw data as shorts.
#
#@param curve the curve to use.
#@param count a pointer to a size_t to store the curve size in.
#
#@returns a pointer to the curve data.  This data is not guaranteed
#to be valid beyond the next non-const curve call.  If the curve is
#a pure gamma curve (no associated points), NULL is returned and the
#count is 0.  This also returns NULL if the curve is a piecewise curve.
#"""


#"""Get pointer to the curve's raw data as unsigned shorts.
#
#@param curve the curve to use.
#@param count a pointer to a size_t to store the curve size in.
#
#@returns a pointer to the curve data.  This data is not guaranteed
#to be valid beyond the next non-const curve call.  If the curve is
#a pure gamma curve (no associated points), NULL is returned and the
#count is 0.  This also returns NULL if the curve is a piecewise curve.
#"""


#"""Get the underlying stp_sequence_t data structure which stp_curve_t is derived from.
#
#This can be used for fast access to the raw data.
#
#@param curve the curve to use.
#
#@returns the stp_sequence_t.  If the curve is a piecewise curve, the
#sequence returned is NULL;
#"""


#"""Set the gamma of a curve.
#This replaces all existing points along the curve.
#The bounds are set to 0..1.  If the gamma value is
#positive, the function is increasing; if negative, the function is
#decreasing.  Count must be either 0 or at least 2.  If the count is
#zero, the gamma of the curve is set for interpolation purposes, but
#points cannot be assigned to.  It is illegal to set gamma on a
#wrap-mode curve.  The resulting curve is treated as a dense
#(equally-spaced) curve.
#
#@param curve the curve to use.
#@param f_gamma the gamma value to set.
#
#@returns FALSE if the gamma value is illegal (0, infinity, or NaN),
#or if the curve wraps around.
#"""


#"""Get the gamma value of the curve.
#
#@returns the gamma value.  A value of 0 indicates that the curve
#does not have a valid gamma value.
#"""


#"""Set a point along the curve.
#
#This call destroys any gamma value assigned to the curve.
#
#@param curve the curve to use.
#@param where the point to set.
#@param data the value to set where to.
#
#@returns FALSE if data is outside the valid bounds or if where is
#outside the number of valid points.  This also returns NULL if
#the curve is a piecewise curve.
#"""


#"""Get a point along the curve.
#
#@param curve the curve to use.
#@param where the point to get.
#@param data a pointer to a double to store the value of where in.
#
#@returns FALSE if where is outside of the number of valid
#points.  This also returns NULL if the curve is a piecewise curve.
#"""


#"""Interpolate a point along the curve.
#
#@param curve the curve to use.
#@param where the point to interpolate.
#@param result a pointer to double to store the value of where in.
#If interpolation would produce a value outside of the allowed range
#(as could happen with spline interpolation), the value is clipped
#to the range.
#
#@returns FALSE if 'where' is less than 0 or greater than the number
#of points, an error is returned.  Also returns FALSE if the curve
#is a piecewise curve.
#"""


#"""Resample a curve (change the number of points).
#
#This does not destroy the gamma value of a curve.
#Points are interpolated as required; any interpolation
#that would place points outside of the
#bounds of the curve will be clipped to the bounds.  The resulting
#curve is always dense (equally-spaced).  This is the correct way
#to convert a piecewise curve to an equally-spaced curve.
#
#@param curve the curve to use (must not exceed 1048576).
#@param points the number of points.
#
#@returns FALSE if the number of points is invalid (less than two,
#except that zero points is permitted for a gamma curve).
#"""


#"""Rescale a curve (multiply all points by a scaling constant).
#
#This also rescales the bounds.  Note that this currently destroys the
#gamma property of the curve.
#
#@param curve the curve to use.
#@param scale the scaling factor.
#@param mode the composition mode.
#@param bounds_mode the bounds exceeding mode.
#
#@returns FALSE if this would exceed floating point limits
#"""
#
#"""Write a curve to a file.
#
#The printable representation is guaranteed to contain only 7-bit
#printable ASCII characters, and is null-terminated.  The curve will
#not contain any space, newline, single quote, or comma characters.
#Furthermore, a printed curve will be read back correctly in all locales.
#These calls are not guaranteed to provide more than 6 decimal places
#of precision or +/-0.5e-6 accuracy, whichever is less.
#
#@warning NOTE that these calls are not thread-safe!  These
#routines may manipulate the locale to achieve a safe
#representation.
#
#@param file the file to write.
#@param curve the curve to use.
#
#@returns 1 on success, 0 on failure.
#"""


#"""Write a curve to a string.
#
#The printable representation is guaranteed to contain only 7-bit
#printable ASCII characters, and is null-terminated.  The curve will
#not contain any space, newline, or comma characters.  Furthermore,
#a printed curve will be read back correctly in all locales.
#These calls are not guaranteed to provide more than 6 decimal places
#of precision or +/-0.5e-6 accuracy, whichever is less.
#
#@warning NOTE that these calls are not thread-safe!  These
#routines may manipulate the locale to achieve a safe representation.
#
#@param curve the curve to use.
#
#@returns a pointer to a string.  This is allocated on the heap, and
#it is the caller's responsibility to free it.
#"""


#"""Create a curve from a stream.
#
#@warning NOTE that these calls are not thread-safe!  These
#routines may manipulate the locale to achieve a safe representation.
#
#@param fp the stream to read.
#
#@returns the newly created curve, or NULL if an error occured.
#"""


#"""Create a curve from a stream.
#
#@warning NOTE that these calls are not thread-safe!  These
#routines may manipulate the locale to achieve a safe representation.
#
#@param file the file to read.
#
#@returns the newly created curve, or NULL if an error occured.
#"""


#"""Create a curve from a string.
#
#@warning NOTE that these calls are not thread-safe!  These
#routines may manipulate the locale to achieve a safe representation.
#
#@param string the string to read.
#
#@returns the newly created curve, or NULL if an error occured.
#"""


#"""Compose two curves, creating a third curve.
#
#Only add and multiply composition is currently supported.
#If both curves are gamma curves with the same sign, and the
#operation is multiplication or division, the returned curve is a
#gamma curve with the appropriate number of points.
#Both a and b must have the same wraparound type.
#
#@param retval a pointer to store the location of the newly-created
#output curve in.
#@param a the first source curve.
#@param b the second source curve.
#@param mode the composition mode.
#@param points the number of points in the output curve (must not
#exceed 1048576).  It must be at least two, unless the curve is a
#gamma curve and the operation chosen is multiplication or division.
#If -1, the resulting number of points will be the least common
#multiplier of the number of points in the input and output curves
#(but will not exceed 1048576).
#
#@returns FALSE if element-wise composition fails.
#"""

