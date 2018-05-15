#!/bin/bash
echo 127.0.0.1 $(hostname) >> /etc/hosts
echo 52.247.160.149 git.cybbh.space >> /etc/hosts
sed -i's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y upgrade
pkg_array=({locate,netcat,dnsutils,curl,lsof,ftp,telnet,wireshark,tcpdump,p0f,scapy,nmap,proxychains,pv,nginx,proftpd,gdebi,install,ethtool,git,make,gcc,flex,bison,build-essential,checkinstall,libpcap-dev,libnet1-dev,libpcre3-dev,libnetfilter-queue-dev,iptables-dev,libdumbnet-dev,zlib1g-dev})
for x in ${pkg_array[@]}; do apt-get install -y $x; done
cd /
wget https://git.cybbh.space/CCTC/public/raw/master/heat/networking/packages_and_scripts/daq_2.0.6-1_amd64.deb
wget https://git.cybbh.space/CCTC/public/raw/master/heat/networking/packages_and_scripts/snort_2.9.9.0-1_amd64.deb
gdebi --non-interactive "daq_2.0.6-1_amd64.deb"
gdebi --non-interactive "snort_2.9.9.0-1_amd64.deb"
mkdir /etc/snort
mkdir /etc/snort/rules
mkdir /var/log/snort
ldconfig
cd /etc/snort
touch snort.conf
echo "include /etc/snort/rules/icmp.rules" >> snort.conf
cd rules
touch icmp.rules
echo "alert icmp any any -> any any (msg:"ICMP detected"; sid:111; rev:1;)" >> icmp.rules
git clone http://github.com/iagox86/dnscat2.git
echo "INSTALLS COMPELTE" 
cd dnscat2/client
make
#Disable TCP Offloading
cat <<EOF > /etc/network/if-up.d/tcpoffload
#!/bin/bash
if [ $IFACE = \"eth1\" ]; then
    /sbin/ethtool -K eth1 tx off sg off tso off
fi
EOF
chmod +x /etc/network/if-up.d/tcpoffload
echo "CREATE USER"
useradd $user -m -U -s /bin/bash
usermod -aG sudo $user
echo "root:$password" | chpasswd
echo "$user:$password" | chpasswd
reboot