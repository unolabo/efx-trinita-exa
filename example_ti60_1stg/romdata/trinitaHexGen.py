import sys

def genhex(binfile):
    hex_origin = binfile.replace('.bin', '.hex')
    f_hex = open(hex_origin, 'w')
    f_hex_div = []
    for i in range(4):
        fn = binfile.replace('.bin', '') + '%d' % i +'.hex'
        f_hex_div.append(open(fn, 'w'))
        
    f = open(binfile, 'rb')
    
    while True:
        bytes = f.read(4)
        if len(bytes) == 0:
            break
        data = bytes[::-1].hex()
        f_hex.write(data + '\n')
        for i in range(4):
            index = 6-(i*2)
            f_hex_div[i].write(data[index:index+2] + '\n')
    

if __name__ == '__main__':
    #sys.argv[1] = binary filename
    genhex(sys.argv[1])
    