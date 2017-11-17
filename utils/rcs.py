#!/bin/python
import sys
i = open(sys.argv[1],"rb").read()
o = open(sys.argv[2],"wb")

p = 0
for third in range(0,3):
    for col in range(0,32):
        for row in range(0,8):
            for lin in range(0,8):
                o.write(i[(((((third << 3) + lin) << 3)+row)<<5)+col])
                p = p + 1
for p in range(6144,6912):
    o.write(i[p])

