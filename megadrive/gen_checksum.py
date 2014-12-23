#!/usr/bin/env python

import sys, struct

f = open( sys.argv[1], 'r+b' )
f.seek( 0x200, 0 ) # skip header
romdata = f.read()
cnt = len(romdata) / 2
checksum = sum( struct.unpack( ">%sH"%(cnt), romdata) )&0xffff
f.seek(0x18e,0) # seek to checksum position in rom
f.write( struct.pack(">H",checksum) ) # write checksum
f.close()
print "Rom checksum %s witten to file %s"%(hex(checksum), sys.argv[1] )
