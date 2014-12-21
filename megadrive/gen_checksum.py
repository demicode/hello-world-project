#!/usr/bin/env python

import sys, struct

f = open( sys.argv[1], 'r+b' )
f.seek( 0x200, 0 )
romdata = f.read()
cnt = len(romdata) / 2
checksum = sum( struct.unpack( ">%sH"%(cnt), romdata) )&0xffff
f.seek(0x18e,0)
f.write( struct.pack(">H",checksum) )
f.close()
print "Rom checksum %s witten to file %s"%(hex(checksum), sys.argv[1] )
