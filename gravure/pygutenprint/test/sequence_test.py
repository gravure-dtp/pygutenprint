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

    a = array("l", range(15))
    stp_seq = stp.Sequence(a, low=0,  high=20)
    for i in range(15):
        eq_(a[i], stp_seq[i])
    eq_(15,  len(stp_seq))

    a = array("f", range(-15, 0))
    stp_seq = stp.Sequence(a, low=-20,  high=20)
    for i in range(15):
        eq_(a[i], stp_seq[i])
    eq_(15,  len(stp_seq))


#--------------------------------------------------------------------------------
# __len__()                                                                            #
#                                                                                           #
def test_len():
    stp_seq = stp.Sequence()
    stp_seq.set_size(30)
    eq_(len(stp_seq), 30)
    stp_seq.set_size(44)
    eq_(len(stp_seq), 44)
    stp_seq = stp.Sequence()
    eq_(len(stp_seq), 0)

#--------------------------------------------------------------------------------
# set_size()                                                                           #
#                                                                                            #
def test_set_size():
    a = array("f", range(-15, 0))
    stp_seq = stp.Sequence(a, low=-20,  high=20)
    stp_seq.set_size(30)
    for i in range(30):
        eq_(0, stp_seq[i])
    eq_(30,  len(stp_seq))
    eq_((-20, 20), stp_seq.get_bounds())

#-------------------------------------------------------------------------------
# set_bounds()                                                                   #
#                                                                                         #
def test_bounds():
    a = array("f", range(-15, 0))
    stp_seq = stp.Sequence(a, low=-20,  high=20)
    eq_((-20, 20), stp_seq.get_bounds())
    stp_seq.set_bounds(3, 10)
    eq_((3, 10), stp_seq.get_bounds())
    assert_raises(ValueError, stp_seq.set_bounds, 5,  2)
    assert_raises(stp.SequenceBoundsError,  stp_seq.__setitem__, 4,  22)

#-------------------------------------------------------------------------------
# ranges                                                                             #
#                                                                                         #
def test_range():
    a = array("f", range(-15, 0))
    stp_seq = stp.Sequence(a, low=-20,  high=20)
    eq_(stp_seq.get_range(),  (-15, -1))
    eq_(stp_seq.min(),  -15)
    eq_(stp_seq.max(),  -1)
    stp_seq.set_size(10)
    eq_(stp_seq.get_range(), (0, 0))


#--------------------------------------------------------------------------------
# __setitem__()                                                                     #
#                                                                                            #
def setitem_base_test():
    a = array("f", range(-15, 0))
    stp_seq = stp.Sequence(a, low=-20,  high=20)
    assert_equal(stp_seq.__setitem__(12,.34), None)
    assert_equal(stp_seq[12], .34)
    assert_equal(stp_seq.__setitem__(-2, 10), None)
    assert_equal(stp_seq[13], 10)
    #TODO: assert_equal(stp_seq[-2], 10)

    #Errors
    assert_raises(IndexError, stp_seq.__setitem__, 20, 4)
    a = array("f", range(0, 10))
    stp_seq = stp.Sequence(a, low=-2,  high=20)
    arg = [5, -2.34]
    assert_raises(stp.SequenceBoundsError, stp_seq.__setitem__, *arg)
    arg = [5, -2.00000000000001]
    assert_raises(stp.SequenceBoundsError, stp_seq.__setitem__, *arg)
    arg=[3, float('nan')]
    assert_raises(stp.SequenceNaNError, stp_seq.__setitem__, *arg)
    arg=[3, float('inf')]
    assert_raises(stp.SequenceBoundsError, stp_seq.__setitem__, *arg)
    arg=[3.2, .33]
    assert_raises(TypeError, stp_seq.__setitem__, *arg)

#SLICES
def setitem_slice_test():
    stp_seq = stp.Sequence(low=-2,  high=20)
    stp_seq.set_size(20)
    stp_seq[0:-1] = 3.33
    for i in range(20):
        eq_(stp_seq[i], 3.33)
    stp_seq[:] = 5.33
    for i in range(20):
        eq_(stp_seq[i], 5.33)
    stp_seq[0:10] = 4.33
    for i in range(10):
        eq_(stp_seq[i], 4.33)

def setitem_slice_test2():
    stp_seq = stp.Sequence(low=-2,  high=20)
    stp_seq.set_size(20)
    a = array('d', [.1,.2,.3,.4,.5,.6,.7,.8,.9,.95])
    stp_seq[3:13] = a
    for i in range(3, 13):
        assert_equal(a[i-3], stp_seq[i])

    # seq[i:j] = t where j-i == len(t) and i+len(t) <= len(seq)
    #                    j-i == 10     and i+10 <= 30

    #FIXME:
    # j > len()
    stp_seq.set_size(20)
    stp_seq[20:66] = a
    assert_equal(stp_seq[19], 0)

    # i = '' >> 0
    stp_seq[:10] = a
    assert_equal(stp_seq[0], .1)

    # i = None >> 0
    stp_seq.set_size(30)
    stp_seq[:10] = a
    assert_equal(stp_seq[0], .1)

    # j = '' >> len()
    stp_seq[20:] = a
    assert_equal(stp_seq[20], .1)

    # j = None >> len()
    stp_seq.set_size(30)
    stp_seq[20:None] = a
    assert_equal(stp_seq[20], .1)

    stp_seq.set_size(20)
    arg=[slice(None,None), a]
    assert_raises(ValueError, stp_seq.__setitem__, *arg)

    stp_seq.set_size(10)
    arg=[slice(None,None), a]

    # negative index
    stp_seq.set_size(20)
    stp_seq[-22:-10] = a # >> [0:10]
    v = 0
    for i in a:
        assert_equal(i, stp_seq[v])
        v += 1


# python sequence type should accept negative index
def setitem_negative_index_test():
    stp_seq = stp.Sequence()
    stp_seq.set_size(30)
    stp_seq[-1]=.9
    stp_seq[-2]=.8
    stp_seq[-29]=.2
    stp_seq[-30]=.1
    assert_equal(stp_seq[29], .9)
    assert_equal(stp_seq[28], .8)
    assert_equal(stp_seq[1], .2)
    assert_equal(stp_seq[0], .1)
    assert_raises(IndexError, stp_seq.__setitem__, -31,  .33333)


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




#--------------------------------------------------------------------------------
# Main                                                                                  #
#                                                                                           #
from nose.plugins.testid import TestId
from nose.config import Config

if __name__ == '__main__':
    test_new()
    nose.runmodule(name='__main__')

#----------------------------------------------------------------------------
# BENCHMARK                                                                 #
#                                                                           #
#----------------------------------------------------------------------------

