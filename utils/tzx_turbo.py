#!/usr/bin/python

import sys

if len(sys.argv) < 3:
    print "usage: %s <in.tzx> <out.tzx>" % (sys.argv[0])
    
src = open(sys.argv[1],"rb").read()
dst = open(sys.argv[2],"wb")

dst.write(src[0:10])


dst.write("\x11\x78\x08\xCA\x02\xCA\x02\xC6\x01\x8B\x03\x97\x0C\x08")

dst.write(src[35:39])
dst.write("\000")
dst.write(src[39:])
                                        

