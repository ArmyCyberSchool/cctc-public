import socket, sys, binascii
from struct import *
 
# Create a raw socket. Note that the print statement is per python 2.7. If you are running this with python 3.0 you will need to format accourdingly.
try:
    s = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_RAW)
except socket.error as msg:
    print 'Socket creation failed!. Error Code : ' + str(msg[0]) + ' Message ' + msg[1]
    sys.exit()
     
# Construct the packet. We are going to add the IP header, then just stick some data in it since a raw socket can handle this.
packet = '';
 
source_ip = '10.1.0.2'	# This is your H1 client...but you can spoof this address if you want!
dest_ip = '10.1.0.1' 	# This is the "router" in your environment, but it can be wherever you want to send the packets.	
 
# IP header info in decimal. You need to consider the full field size and the decimal therein. The ip_ihl_ver field for example is actually read as 2 nibbles, however for ease of coding, we're going to just use the decimal value of the entire byte, assuming that the packet is not using IP options.
ip_ver_ihl = ?	# Decimal representing '0x45', as this is the first byte of a normal IPv4 packet.
ip_tos = ?	    # Type of service/QoS
ip_len = 0      # kernel will fill this in
ip_id = ?       # IP ID of this packet, this value can just be made-up
ip_frag = ?	    # This is not a fragmented packet...but you could make it one if you wanted!
ip_ttl = ?	    # Use the TTL of Linux
ip_proto = ?	# Use a valid IP protocol number that isnt' TCP/UDP...think outside the box and reference IANA (https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml)
ip_check = 0    # kernel will fill the correct checksum
ip_saddr = socket.inet_aton ( source_ip )
ip_daddr = socket.inet_aton ( dest_ip )
 
# This portion creates the header by packing the above variables into a structure. The ! in the string means network order, while the code following specifies how to store the info. These "?"'s should indicate the size of the field that the information contained in the corresponding variables should be stored in. The "?"'s should be replaces with B, H or 4s. B=Byte, H=Half-word, 4s=four bytes (a str is a byte long)
ip_header = pack('!????????????' , ip_ver_ihl, ip_tos, ip_len, ip_id, ip_frag, ip_ttl, ip_proto, ip_check, ip_saddr, ip_daddr)
 
# Your custom protocol fields or data. We are going to just insert data here. Add your message where the "?" is. Ensure you obfuscate it though...don't want any clear text messages being spotted! You can use a function from the binascii module as in this example, or you can use something else.
user_data = '?'
hidden_msg = ?(user_data)
 
# final packet creation
packet = ip_header + hidden_msg
 
#Send the packet
s.sendto(packet, (dest_ip , 0 ))