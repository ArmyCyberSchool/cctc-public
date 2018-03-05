import socket, sys, binascii, ipaddress, subprocess
from struct import *
from random import randint

# Get local machine IP

a = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
a.connect(('1.2.3.4', 0))
source_ip = a.getsockname()[0]
b = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_RAW)
b.bind((source_ip, 1))

# Create a raw socket to send scan thru
try:
    s = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_RAW)
except socket.error as msg:
#    print (Socket creation failed!. Error Code :  + str(msg[0]) + ' Message ' + msg[1])
    sys.exit()

# Prompt user to enter an IP Network
net_addr = input("Enter a network address in CIDR format(ex.192.168.0.0/24): ")
start = int(input("What is the starting port for the scan?  "))
y = int(input("What is the ending port or the scan?  "))
end = y + 1
ip_net = ipaddress.ip_network(net_addr)

# Prompt the user for the type of scan
type = int(input("Enter type of scan [1:NULL  2:FIN  3:SYN  4:XMAS]-   "))

for i in ip_net.hosts():

# Construct the packet. We are going to add the IP header, then just stick some data in it since a raw socket can handle this.
  packet = '';
  dest_ip = str(i)


# IP header info in decimal. You need to consider the full field size and the decimal therein. The ip_ihl_ver field for example is actually read as 2 nibbles, however for ease of coding, we're going to just use the decimal value of the entire byte, assuming that the packet is not using IP options.
  ip_proto = socket.IPPROTO_TCP
  ip_saddr = socket.inet_aton ( source_ip )
  ip_daddr = socket.inet_aton ( dest_ip )

# The ! in the pack format string means network order while the code following specifies how to store the info...B=Byte, H=Half-word, 4s=four x str (byte)
  ip_header = pack('!BBHHHBBH4s4s' , 69, 0, 0, 12345, 0, 64, ip_proto, 0, ip_saddr, ip_daddr)


#NULL SCAN

for i in range(start, end):
    tcp_source = 65535
    tcp_dest = int(i)   # destination port
    tcp_seq = randint(0, 1000)
    tcp_ack_seq = 0
    tcp_doff = 5    #4 bit field, size of tcp header, 5 * 4 = 20 bytes
    if type == 1:
#NULL SCAN- no tcp flags set
      tcp_flags = 0
    elif type == 2:
#FIN SCAN- no tcp flags set
      tcp_flags = 1
    elif type == 3:
#SYN SCAN
      tcp_flags = 2
#XMAS TREE SCAN
    tcp_flags = 41
  elif type == 4:
#ACK SCAN
      tcp_flags = 16
  else:
    print ("Invalid Scan Choice")
   
#Continue with TCP header info
    tcp_window = socket.htons (5840)    #   maximum allowed window size
    tcp_offset_res = (tcp_doff << 4) + 0
 
# the ! in the pack format string means network order
    tcp_header = pack('!HHLLBBHHH' , tcp_source, tcp_dest, tcp_seq, tcp_ack_seq, tcp_offset_res, tcp_flags,  tcp_window, 0, 0)


# final packet creation
    packet = ip_header + tcp_header

#Send the packet
    s.sendto(packet, (dest_ip , 0 ))

sys.exit(0)


