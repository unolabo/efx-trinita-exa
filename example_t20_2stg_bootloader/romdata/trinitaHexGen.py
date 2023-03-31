# -*- coding: utf-8 -*-

import sys

def genhex(binfile, sa, oa):
    hex_origin = binfile.replace('.bin', '.hex')
    f_hex = open(hex_origin, 'w')
    f_hex_div = []
    for i in range(4):
        fn = binfile.replace('.bin', '') + '%d' % i +'.hex'
        f_hex_div.append(open(fn, 'w'))
        
    f = open(binfile, 'rb')
    
    
    current_address = int(sa.replace('0x', ''), 16)
    offset_address  = int(oa.replace('0x', ''), 16)
    
    while True:
        bdata = b"\xFF\xFF\xFF\xFF"
        if (current_address >= offset_address):
            bdata = f.read(4)

        if len(bdata) == 0:
            break
        data = bdata[::-1].hex()
        f_hex.write(data + '\n')
        for i in range(4):
            index = 6-(i*2)
            f_hex_div[i].write(data[index:index+2] + '\n')
        current_address = current_address + 4
    

if __name__ == '__main__':
    #sys.argv[1] = binary filename
    num = len(sys.argv)
    if (num == 4):
        genhex(sys.argv[1], sys.argv[2], sys.argv[3])
    else:
        genhex(sys.argv[1], "0xF9000000", "0xF9000000")

