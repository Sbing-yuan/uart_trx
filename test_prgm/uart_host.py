# use raspberry pi pico uart0 to test
from machine import UART
import time
import random

uart = UART(0, 9600)                         # init with given baudrate
uart.init(9600, bits=8, parity=None, stop=1) # init with given parameters

def write(addr, data):
    mask_7bit = 0b0111_1111
    mask_8bit = 0b1111_1111
    addr_7bit = addr & mask_7bit
    data_8bit = data & mask_8bit
    print("write_1byte, addr: %3d, data: %3d" % (addr_7bit, data_8bit))
    waddr_8bit = 0b1000_0000 | addr_7bit
    uart.write(waddr_8bit.to_bytes(1, 'big'))
    uart.write(data_8bit.to_bytes(1, 'big'))
    time.sleep(0.01)

def read(addr):
    mask_7bit = 0b0111_1111
    addr_7bit = addr & mask_7bit
    print("read_1byte, addr: %3d" % (addr_7bit))
    raddr_8bit = 0b0000_0000 | addr_7bit
    uart.write(raddr_8bit.to_bytes(1, 'big'))
    time.sleep(0.01)
    ret_data = uart.read()
    #print(type(ret_data))
    print("return data: %3d " % (int.from_bytes(ret_data, 'big')))

for addr in range(128):
    read(addr)

for addr in range(128):
    rand_data = random.randint(0,255)
    write(addr, rand_data)
    
for addr in range(128):
    read(addr)    