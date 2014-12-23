#!/usr/bin/env python

import sys, struct

f = open( sys.argv[1], 'r+b' )

f.seek( 0xa0, 0 ) # skip header
romdata = f.read( 0xbd-0xa0 )

cnt = len(romdata)
checksum = sum( struct.unpack( "%sb"%(cnt), romdata) ) & 0xff
compliment = (-(0x19+checksum)) &0xff

f.seek( 0xbd, 0 ) # seek to compliment position in rom

r = struct.pack("B",compliment)

f.write( r ) # write checksum
f.close()
print "ROM compliment %s witten to file %s"%( r, sys.argv[1] )
