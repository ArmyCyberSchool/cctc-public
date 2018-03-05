from scapy.all import *
import sys
import binascii

  file = open('text.txt', 'r')
  line = file.readlines()
  for x in line:
    message = binascii.hexlify(x)
    packet = IP(dst="8.8.8.8")/ICMP()/message
    send(packet)
    packet.show()