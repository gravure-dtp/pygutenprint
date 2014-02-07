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

import sys
import time

import numpy as np
from array import array
import timeit

import nose
from nose import *
from nose.tools import *
from nose.failure import *

import cython
import gravure.pygutenprint.sequence as stp

#--------------------------------------------------------------------------------
# Object creation                                                                #
#                                                                                           #
def test_new():
    stp_seq = stp.Sequence()
    assert_is_instance(stp_seq, stp.Sequence)
    eq_(len(stp_seq),  0)
    stp_seq = stp.Sequence(low=0.2,  high=1.7)
    eq_(stp_seq.get_bounds(),  (0.2, 1.7))

    print(stp_seq)
    a = array("l", range(15))
    stp_seq = stp.Sequence(a, low=0,  high=20)
    print(stp_seq)


#--------------------------------------------------------------------------------
# Object deallocation                                                           #
#                                                                               #


##--------------------------------------------------------------------------------
## __len__()                                                                     #
##                                                                               #
#def test_len():
#    stp_seq = stp.Sequence()
#    print(len(stp_seq))
#    stp_seq.set_size(30)
#    print(len(stp_seq))
#    eq_(len(stp_seq), 30)
#    stp_seq.set_size(44)
#    eq_(len(stp_seq), 44)
#    stp_seq = stp.Sequence()
#    eq_(len(stp_seq), 0)
#
##--------------------------------------------------------------------------------
## set_size()                                                                  #
##                                                                               #
#def test_set_size():
#    assert_equal(STP_SEQ[3], 0)
#    assert_equal(STP_SEQ[29], 0)
#    assert_equal(len(STP_SEQ),30)
#
##--------------------------------------------------------------------------------
## __setitem__()                                                                 #
##                                                                               #
## 3 errors could occurs : - index error
##                       - data not isFinite
##                       - data is out of bounds (default bounds are (0, 1.0))
#def setitem_base_test():
#    global STP_SEQ
#    # return None when ok
#    assert_equal(STP_SEQ.__setitem__(12,.34), None)
#    assert_equal(STP_SEQ[12], .34)
#
##ERRORS
## basic index error on sequence
#def setitem_IndexError_test():
#    global STP_SEQ
#    arg = [32, 1]
#    assert_raises(IndexError, STP_SEQ.__setitem__, *arg)
#
## value set can't be out of bounds attribute
#def setitem_BoundsError_test():
#    global STP_SEQ
#    arg = [5, 2.34]
#    assert_raises(stp.SequenceBoundsError, STP_SEQ.__setitem__, *arg)
#    arg = [5, -3.54]
#    assert_raises(stp.SequenceBoundsError, STP_SEQ.__setitem__, *arg)
#    arg = [5, -1.0000000000000001]
#    assert_raises(stp.SequenceBoundsError, STP_SEQ.__setitem__, *arg)
#
## SequenceNaNError, value pass is no a finite number.
#def setitem_NaNError_test():
#    global STP_SEQ
#    arg=[3, float('nan')]
#    assert_raises(stp.SequenceNaNError, STP_SEQ.__setitem__, *arg)
#    arg=[3, float('inf')]
#    assert_raises(stp.SequenceNaNError, STP_SEQ.__setitem__, *arg)
#
#def setitem_TypeError_test():
#    global STP_SEQ
#    arg=[3.2, .33]
#    assert_raises(TypeError, STP_SEQ.__setitem__, *arg)
#
##SLICES
#def setitem_slice_TypeError_test():
#    global STP_SEQ
#    arg=[slice(0,10), 0.8]
#    assert_raises(TypeError, STP_SEQ.__setitem__, *arg)
#    arg=[slice(0,10), '1234567890']
#    assert_raises(TypeError, STP_SEQ.__setitem__, *arg)
#
#def setitem_slice_ExtendedError_test():
#    global STP_SEQ
#    li = [.1,.2,.3,.4,.5,.6,.7,.8,.9,.95]
#    arg=[slice(0,10,2), li]
#    assert_raises(NotImplementedError, STP_SEQ.__setitem__, *arg)
#
## Sequence couldn't change its size without zero all its data !!
## So we accept assignement by slice only with parameters that
## don't affect size.
## The only case who verify this condition is for assignement:
## seq[i:j] = t where j-i == len(t) and i+len(t) <= len(seq)
#def setitem_slice_IndexError_test():
#    global STP_SEQ
#    li = [.1,.2,.3,.4,.5,.6,.7,.8,.9,.95]
#    # j-i < len(li)
#    arg=[slice(2,8), li]
#    assert_raises(IndexError, STP_SEQ.__setitem__, *arg)
#
#    # j-i > len(li)
#    arg=[slice(2,16), li]
#    assert_raises(IndexError, STP_SEQ.__setitem__, *arg)
#
#    # i+len(li) > len(STP_SEQ)
#    arg=[slice(22,32), li]
#    assert_raises(IndexError, STP_SEQ.__setitem__, *arg)
#
#def setitem_slice_test():
#    global STP_SEQ
#    li = [.1,.2,.3,.4,.5,.6,.7,.8,.9,.95]
#    # ok
#    STP_SEQ[3:13] = li
#    for i in li:
#        assert_equal(li[i], STP_SEQ[3+i])
#    # not a shallow copy
#    li[0] = -1
#    assert_equal(STP_SEQ[3], .1)
#
#def setitem_slice2_test():
#    global STP_SEQ
#    li = [.1,.2,.3,.4,.5,.6,.7,.8,.9,.95]
#
#    # seq[i:j] = t where j-i == len(t) and i+len(t) <= len(seq)
#    #                    j-i == 10     and i+10 <= 30
#
#    # j > len()
#    STP_SEQ[20:66] = li
#    assert_equal(STP_SEQ[20], .1)
#
#    # i > len() always an error
#    arg=[slice(66,76), li]
#    assert_raises(IndexError, STP_SEQ.__setitem__, *arg)
#
#    # i = '' >> 0
#    STP_SEQ[:10] = li
#    assert_equal(STP_SEQ[0], .1)
#
#    # i = None >> 0
#    STP_SEQ.set_size(30)
#    STP_SEQ[:10] = li
#    assert_equal(STP_SEQ[0], .1)
#
#    # j = '' >> len()
#    STP_SEQ[20:] = li
#    assert_equal(STP_SEQ[20], .1)
#
#    # j = None >> len()
#    STP_SEQ.set_size(30)
#    STP_SEQ[20:None] = li
#    assert_equal(STP_SEQ[20], .1)
#
#    # i & j == None >> always raise exception
#    arg=[slice(None,None), li]
#    assert_raises(IndexError, STP_SEQ.__setitem__, *arg)
#
#    # i >= j >> always raise exception
#    arg=[slice(30, 20), li]
#    assert_raises(IndexError, STP_SEQ.__setitem__, *arg)
#
#    # negative index
#    STP_SEQ[-22:-12] = li # >> [8:18]
#    for i in li:
#        assert_equal(li[i], STP_SEQ[i+8])
#
#
##OTHERS
## integer should be converted to float
#def setitem_type_cast_test():
#    global STP_SEQ
#    STP_SEQ[13] = 1
#    assert_equal(STP_SEQ[13], 1.00000000)
#    assert_true(isinstance(STP_SEQ[13], float))
#
## python sequence type should accept negative index
#def setitem_negative_index_test():
#    global STP_SEQ
#    STP_SEQ[-1]=.9
#    STP_SEQ[-2]=.8
#    STP_SEQ[-29]=.2
#    STP_SEQ[-30]=.1
#    assert_equal(STP_SEQ[29], .9)
#    assert_equal(STP_SEQ[28], .8)
#    assert_equal(STP_SEQ[1], .2)
#    assert_equal(STP_SEQ[0], .1)
#    arg=[-31, .333333]
#    assert_raises(IndexError, STP_SEQ.__setitem__, *arg)
#
#
##------------------------------------------------------------------------------
## __getitem__()
##
## should implement slicing and negative index
## when slicing should return deep copy
## could raise TypeError, IndexError
#
#def getitem_base_test():
#    global STP_SEQ
#    assert_equal(STP_SEQ[12], 0)
#    STP_SEQ[12] = .22
#    a = STP_SEQ[12]
#    assert_equal(a, .22)
#    a = .33
#    assert_equal(STP_SEQ[12], .22)
#
#def getitem_negative_index_test():
#    global STP_SEQ
#    STP_SEQ[29]=.9
#    STP_SEQ[28]=.8
#    STP_SEQ[1]=.2
#    STP_SEQ[0]=.1
#    assert_equal(STP_SEQ[-1], .9)
#    assert_equal(STP_SEQ[-2], .8)
#    assert_equal(STP_SEQ[-29], .2)
#    assert_equal(STP_SEQ[-30], .1)
#    arg=[-31]
#    assert_raises(IndexError, STP_SEQ.__getitem__, *arg)
#
##ERRORS
#def getitem_TypeError_test():
#    global STP_SEQ
#    arg=[2.2]
#    assert_raises(TypeError, STP_SEQ.__getitem__, *arg)
#    arg=[None]
#    assert_raises(TypeError, STP_SEQ.__getitem__, *arg)
#
#def getitem_IndexError_test():
#    global STP_SEQ
#    arg=[30]
#    assert_raises(IndexError, STP_SEQ.__getitem__, *arg)
#    arg=[-31]
#    assert_raises(IndexError, STP_SEQ.__getitem__, *arg)
#
##SLICES
#def getitem_slice1_test():
#    global STP_SEQ
#    for i in range(30):
#        STP_SEQ[i] = float(i)/100
#    seq_c = STP_SEQ[:]
#    # object of same type
#    assert_equal(type(STP_SEQ), type(seq_c))
#    # equality
#    assert_not_equal(id(STP_SEQ), id(seq_c))
#    for i in range(30):
#        assert_equal(STP_SEQ[i], seq_c[i])
#    # not a shallow copy
#    stp_c[0] = -1
#    assert_not_equal(STP_SEQ[0], -1)
#
#def getitem_slice2_test():
#    global STP_SEQ
#    for i in range(30):
#        STP_SEQ[i] = float(i)/100
#    stp_c = STP_SEQ[0:30]
#    assert_equal(len(stp_c), 30)
#    stp_c = STP_SEQ[3:15]
#    assert_equal(len(stp_c), 12)
#    for i in range(12):
#        assert_equal(stp_c[i], STP_SEQ[i+3])
#
#    # j > len()
#    stp_c = STP_SEQ[0:66]
#    assert_equal(len(stp_c), 30)
#
#    # i > len()
#    stp_c = STP_SEQ[66:3]
#    assert_equal(len(stp_c), 0)
#
#    # i = '' >> 0
#    stp_c = STP_SEQ[:9]
#    assert_equal(len(stp_c), 9)
#
#    # i = None >> 0
#    stp_c = STP_SEQ[None:9]
#    assert_equal(len(stp_c), 9)
#
#    # j = '' >> len()
#    stp_c = STP_SEQ[10:]
#    assert_equal(len(stp_c), 20)
#
#    # j = None >> len()
#    stp_c = STP_SEQ[20:None]
#    assert_equal(len(stp_c), 10)
#
#    # i & j == None
#    stp_c = STP_SEQ[None:None]
#    assert_equal(len(stp_c), 30)
#
#    # i >= j >> empty slice
#    stp_c = STP_SEQ[2:2]
#    assert_equal(len(stp_c), 0)
#    stp_c = STP_SEQ[10:8]
#    assert_equal(len(stp_c), 0)
#    stp_c = STP_SEQ[-2:-62]
#    assert_equal(len(stp_c), 0)
#
#    # negative index
#    stp_c = STP_SEQ[-22:-2]
#    # >> [8:28]
#    assert_equal(len(stp_c), 20)
#    for i in range(20):
#        assert_equal(stp_c[i], STP_SEQ[i+8])
#
#
#def getitem_extended_slice_test():
#    global STP_SEQ
#    arg=[slice(0,10,2)]
#    assert_raises(NotImplementedError, STP_SEQ.__getitem__, *arg)
#
##------------------------------------------------------------------------------
## __delitem__()
##
#def delitem_test():
#    global STP_SEQ
#    arg=[2]
#    assert_raises(NotImplementedError, STP_SEQ.__delitem__, *arg)
#
##------------------------------------------------------------------------------
## __iter__()
##TODO: More tests, change data sequence while iteration
#def iter_test():
#    global STP_SEQ
#    it = iter(STP_SEQ)
#    assert_true(hasattr(it,'next'))
#
#def next_test():
#    global STP_SEQ
#    li = range(30)
#    for i in li: li[i] = float(i)/100
#    for i in range(30): STP_SEQ[i] = li[i]
#    i = 0
#    for f in STP_SEQ:
#        assert_equal(f, li[i])
#        i +=1
#
#    it = iter(STP_SEQ)
#    for i in range(30):
#        f = it.next()
#        assert_equal(f, li[i])
#    assert_raises(StopIteration, it.next)
#    assert_raises(StopIteration, it.next)
#    it.__iter__()
#    assert_raises(StopIteration, it.next)
#    assert_raises(StopIteration, it.next)
#
#def reversed_test():
#    global STP_SEQ
#    it = reversed(STP_SEQ)
#    assert_true(hasattr(it,'next'))
#
#    li = range(30)
#    for i in li: li[i] = float(i)/100
#    for i in range(30): STP_SEQ[i] = li[i]
#    i = 29
#    for f in reversed(STP_SEQ):
#        assert_equal(f, li[i])
#        i -= 1
#
#    it = reversed(STP_SEQ)
#    for i in reversed(range(30)):
#        f = it.next()
#        assert_equal(f, li[i])
#    assert_raises(StopIteration, it.next)
#    assert_raises(StopIteration, it.next)
#    it.__iter__()
#    assert_raises(StopIteration, it.next)
#    assert_raises(StopIteration, it.next)
#
#
##------------------------------------------------------------------------------
## __contains__()
#def contains_test():
#    global STP_SEQ
#    STP_SEQ[9] = .33
#    STP_SEQ[29] = .22
#    assert_true(.33 in STP_SEQ)
#    assert_true(.22 in STP_SEQ)
#    assert_false(.44 in STP_SEQ)
#
#    assert_false(.33 not in STP_SEQ)
#    assert_false(.22 not in STP_SEQ)
#    assert_true(.44 not in STP_SEQ)
#
#    arg = ['b']
#    assert_raises(AttributeError, STP_SEQ.__contains__, *arg)
#
#
##------------------------------------------------------------------------------
## __str__()    __repr__()
##
#
## str() should return the same as repr()
#def str_test():
#    global  STP_SEQ
#    li = range(30)
#    for i in li: li[i] = float(i)/100
#    for i in range(30): STP_SEQ[i] = li[i]
#    assert_equal(str(STP_SEQ), repr(STP_SEQ))
#
##TODO: with eval(repr(sequence)), should recreate
## a valid Sequence equal to sequence
#def repr_test():
#    global  STP_SEQ
#    li = range(30)
#    for i in li: li[i] = float(i)/100
#    for i in range(30): STP_SEQ[i] = li[i]
#    st = repr(STP_SEQ)
#    li_b = eval(st)
#    assert_true(isinstance(li_b, list))
#    assert_equal(st, repr(li_b))


#------------------------------------------------------------------------------
# __comp__()
#

#-------------------------------------------------------------------------------
# set_bounds()                                                                  #
#                                                                               #


#--------------------------------------------------------------------------------
# Main                                                                          #
#                                                                               #
from nose.plugins.testid import TestId
from nose.config import Config

if __name__ == '__main__':
    test_new()
    #nose.runmodule(name='__main__')

#----------------------------------------------------------------------------
# BENCHMARK                                                                 #
#                                                                           #
#----------------------------------------------------------------------------

