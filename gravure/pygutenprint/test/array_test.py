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

import numpy as np
import array
import timeit

import nose
from nose import *
from nose.tools import *
from nose.failure import *

from  gravure.pygutenprint.array import Array as stp_Array
from  gravure.pygutenprint.sequence import Sequence as Seq


#--------------------------------------------------------------------------------
# Main                                                                                    #
#                                                                                             #
from nose.plugins.testid import TestId
from nose.config import Config

def test():
    #help(stp_Array)
    #s = Seq()
    a = stp_Array(data=[1, 2])

if __name__ == '__main__':
    print("Test")
    test()
    #stp.test_data()
    #nose.runmodule(name='__main__')












