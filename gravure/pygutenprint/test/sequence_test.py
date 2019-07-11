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

#-----------------------------------------------------------------------------
# Object creation                                                            #
#                                                                            #
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


#-----------------------------------------------------------------------------
# __len__()                                                                  #
#                                                                            #
def test_len():
    stp_seq = stp.Sequence()
    stp_seq.set_size(30)
    eq_(len(stp_seq), 30)
    stp_seq.set_size(44)
    eq_(len(stp_seq), 44)
    stp_seq = stp.Sequence()
    eq_(len(stp_seq), 0)

#-----------------------------------------------------------------------------
# set_size()                                                                 #
#                                                                            #
def test_set_size():
    a = array("f", range(-15, 0))
    stp_seq = stp.Sequence(a, low=-20,  high=20)
    stp_seq.set_size(30)
    for i in range(30):
        eq_(0, stp_seq[i])
    eq_(30,  len(stp_seq))
    eq_((-20, 20), stp_seq.get_bounds())

#-----------------------------------------------------------------------------
# set_bounds()                                                               #
#                                                                            #
def test_bounds():
    a = array("f", range(-15, 0))
    stp_seq = stp.Sequence(a, low=-20,  high=20)
    eq_((-20, 20), stp_seq.get_bounds())
    stp_seq.set_bounds(3, 10)
    eq_((3, 10), stp_seq.get_bounds())
    assert_raises(ValueError, stp_seq.set_bounds, 5,  2)
    assert_raises(stp.SequenceBoundsError,  stp_seq.__setitem__, 4,  22)

#-----------------------------------------------------------------------------
# ranges                                                                     #
#                                                                            #
def test_range():
    a = array("f", range(-15, 0))
    stp_seq = stp.Sequence(a, low=-20,  high=20)
    eq_(stp_seq.get_range(),  (-15, -1))
    eq_(stp_seq.min(),  -15)
    eq_(stp_seq.max(),  -1)
    stp_seq.set_size(10)
    eq_(stp_seq.get_range(), (0, 0))

#-----------------------------------------------------------------------------
# copy                                                                       #
#                                                                            #
def test_copy():
    a = array("f", range(-15, 0))
    stp_seq = stp.Sequence(a, low=-20,  high=20)
    stp_seq_c = stp_seq.copy()
    assert_is_instance(stp_seq_c, stp.Sequence)
    ok_(stp_seq_c is not stp_seq)
    eq_(stp_seq_c, stp_seq)
    eq_(len(stp_seq_c),  len(stp_seq))
    for i in range(15):
        eq_(stp_seq[i], stp_seq_c[i])

    stp_seq_c = stp.Sequence()
    stp_seq.set_size(40)
    stp_seq.copy_in(stp_seq_c)
    ok_(stp_seq_c is not stp_seq)
    eq_(stp_seq_c, stp_seq)
    eq_(len(stp_seq_c),  len(stp_seq))
    for i in range(15):
        eq_(stp_seq[i], stp_seq_c[i])

#-----------------------------------------------------------------------------
# reverse                                                                    #
#                                                                            #
def test_reverse():
    a = array("f", range(-15, 0))
    stp_seq = stp.Sequence(a, low=-20,  high=20)
    stp_seq.reverse()
    for i in range(15):
        eq_(stp_seq[i], a[14 - i])

    stp_seq_c = stp_seq.create_reverse()
    stp_seq.reverse()
    ok_(stp_seq_c is not stp_seq)
    eq_(stp_seq_c, stp_seq)
    eq_(len(stp_seq_c),  len(stp_seq))
    for i in range(15):
        eq_(stp_seq[i], stp_seq_c[i])


#-----------------------------------------------------------------------------
# __contains__()                                                             #  
#                                                                            #
def contains_test():
    stp_seq = stp.Sequence()
    stp_seq.set_size(30)
    stp_seq[9] = .33
    stp_seq[29] = .22
    assert_true(.33 in stp_seq)
    assert_true(.22 in stp_seq)
    assert_false(.44 in stp_seq)
    assert_false(.33 not in stp_seq)
    assert_false(.22 not in stp_seq)
    assert_true(.44 not in stp_seq)
    arg = ['b']
    assert_raises(TypeError, stp_seq.__contains__, *arg)


#-----------------------------------------------------------------------------
# __setitem__()                                                              #
#                                                                            #
def setitem_base_test():
    a = array("f", range(-15, 0))
    stp_seq = stp.Sequence(a, low=-20,  high=20)
    assert_equal(stp_seq.__setitem__(12,.34), None)
    assert_equal(stp_seq[12], .34)
    assert_equal(stp_seq.__setitem__(-2, 10), None)
    assert_equal(stp_seq[13], 10)

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


#-----------------------------------------------------------------------------
# __getitem__()                                                              #
#                                                                            #
def getitem_base_test():
    stp_seq = stp.Sequence()
    stp_seq.set_size(30)
    eq_(stp_seq[12], 0)
    stp_seq[12] = .22
    eq_( stp_seq[12], .22)

    stp_seq[29]=.9
    stp_seq[28]=.8
    stp_seq[1]=.2
    stp_seq[0]=.1
    assert_equal(stp_seq[-1], .9)
    assert_equal(stp_seq[-2], .8)
    assert_equal(stp_seq[-29], .2)
    assert_equal(stp_seq[-30], .1)
    arg=[-31]
    assert_raises(IndexError, stp_seq.__getitem__, *arg)

#SLICES
def getitem_slice1_test():
    stp_seq = stp.Sequence()
    stp_seq.set_size(30)
    for i in range(30):
        stp_seq[i] = float(i)/100
    seq_c = stp_seq[:]
    # object of same type
    assert_not_equal(type(stp_seq), type(seq_c))
    # equality
    assert_not_equal(id(stp_seq), id(seq_c))
    for i in range(30):
        assert_equal(stp_seq[i], seq_c[i])
    # shallow copy
    seq_c[0] = -1
    assert_equal(stp_seq[0], -1)

def getitem_slice2_test():
    stp_seq = stp.Sequence()
    stp_seq.set_size(30)
    for i in range(30):
        stp_seq[i] = float(i)/100
    stp_c = stp_seq[0:30]
    assert_equal(len(stp_c), 30)
    stp_c = stp_seq[3:15]
    assert_equal(len(stp_c), 12)
    for i in range(12):
        assert_equal(stp_c[i], stp_seq[i+3])

    # j > len()
    stp_c = stp_seq[0:66]
    assert_equal(len(stp_c), 30)

    # i > len()
    stp_c = stp_seq[66:3]
    assert_equal(len(stp_c), 0)

    # i = '' >> 0
    stp_c = stp_seq[:9]
    assert_equal(len(stp_c), 9)

    # i = None >> 0
    stp_c = stp_seq[None:9]
    assert_equal(len(stp_c), 9)

    # j = '' >> len()
    stp_c = stp_seq[10:]
    assert_equal(len(stp_c), 20)

    # j = None >> len()
    stp_c = stp_seq[20:None]
    assert_equal(len(stp_c), 10)

    # i & j == None
    stp_c = stp_seq[None:None]
    assert_equal(len(stp_c), 30)

    # i >= j >> empty slice
    stp_c = stp_seq[2:2]
    assert_equal(len(stp_c), 0)
    stp_c = stp_seq[10:8]
    assert_equal(len(stp_c), 0)
    stp_c = stp_seq[-2:-62]
    assert_equal(len(stp_c), 0)

    # negative index
    stp_c = stp_seq[-22:-2]
    # >> [8:28]
    assert_equal(len(stp_c), 20)
    for i in range(20):
        assert_equal(stp_c[i], stp_seq[i+8])

    stp_c = stp_seq[0:10:2]
    assert_equal(len(stp_c), 5)

#-----------------------------------------------------------------------------
# Buffer interface                                                           #
#                                                                            #
def  test_buffer():
    a = array("f", range(-15, 0))
    stp_seq = stp.Sequence(a, low=-20,  high=20)
    b = stp_seq.get_data()
    eq_(len(stp_seq), len(b))
    for i in range(15):
        eq_(stp_seq[i], b[i])
    stp_seq[4] = 9.999
    for i in range(15):
        eq_(stp_seq[i], b[i])
    b = stp_seq[5:-1]

    g = stp_seq.get_data()
    print(g.shape)
    print(g.strides)
    print(g.suboffsets)

    x = stp.Sequence(g, low=-20,  high=20)


    eq_(9, len(b))
    seq = stp.Sequence(b, low=-20,  high=20)
#    eq_(9, len(seq))
#    for i in range(9):
#        eq_(stp_seq[i+5], seq[i])


    fl = stp_seq.get_float_data()
    eq_(len(fl), len(stp_seq))


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


#-----------------------------------------------------------------------------
# Main                                                                       #
#                                                                            #
from nose.plugins.testid import TestId
from nose.config import Config

if __name__ == '__main__':

    nose.runmodule(name='__main__')

#-----------------------------------------------------------------------------
# BENCHMARK                                                                  #
#                                                                            #
#-----------------------------------------------------------------------------

