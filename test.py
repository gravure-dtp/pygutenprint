# -*- coding: utf-8 -*-

import sys

from gravure.pygutenprint import sequence as _s
from gravure.pygutenprint import util

import array
import nose


def _test():
    # test linking against libgutenprint
    #libgp = cdll.LoadLibrary("libgutenprint.dylib")
    print('gutenprint.init() : ' + repr(util.init()))
    print('gutenprint version : ' + util.get_version())
    print('gutenprint release version : ' + util.get_release_version())

    sys.argv
    commands = [sys.argv[0], '--verbosity=2']
    nose.run(argv=commands)

    STP_SEQ = _s.Sequence()
    STP_SEQ.reset_size(30)
    li = [.3, .2, .6, .1, .8]
    a = array.array('d', li)
    STP_SEQ.set_data(a)
    print("from python")
    for ii in range(len(STP_SEQ)):
        print(STP_SEQ[ii])
    STP_SEQ.set_data(None)

#    print STP_SEQ[0], STP_SEQ[1], STP_SEQ[2], STP_SEQ[3], STP_SEQ[4]
#    STP_SEQ.get_data()
#    print STP_SEQ[0], STP_SEQ[1], STP_SEQ[2], STP_SEQ[3], STP_SEQ[4]
#    STP_SEQ[0]=.99
#    STP_SEQ[1]=.99
#    STP_SEQ[2]=.99
#    STP_SEQ[3]=.99
#    STP_SEQ[4]=.99
#    print STP_SEQ[0], STP_SEQ[1], STP_SEQ[2], STP_SEQ[3], STP_SEQ[4]
#    STP_SEQ.get_data()
#    print STP_SEQ[0], STP_SEQ[1], STP_SEQ[2], STP_SEQ[3], STP_SEQ[4]

if __name__ == "__main__":
    #_test()
    pass
