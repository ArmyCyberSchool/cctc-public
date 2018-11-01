#!/bin/bash
echo 127.0.0.1 $(hostname) >> /etc/hosts
echo 52.247.160.149 git.cybbh.space >> /etc/hosts
sed -i's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y install ethtool netcat openvpn
echo "INSTALLS COMPELTE"
echo "CREATE NETCAT LISTENERS"
touch /file1.txt
chmod 777 /file1.txt
echo "Buggs Bunny says you are a success" > /file1.txt
touch /file2.txt
chmod 777 /file2.txt
echo "Honey Badger says try again" > /file2.txt
wget -O /etc/init.d/autostart https://git.cybbh.space/CCTC/public/raw/master/heat/networking/packages_and_scripts/autostart  
chmod 777 /etc/init.d/autostart
update-rc.d autostart defaults
#Disable TCP Offloading
cat <<EOF > /etc/network/if-up.d/tcpoffload
#!/bin/bash
/sbin/ethtool -K eth0 tx off sg off tso off
EOF
chmod +x /etc/network/if-up.d/tcpoffload
cd /etc/network/if-up.d/
./tcpoffload
cd /
echo "CREATE USER"
useradd $user -m -U -s /bin/bash
usermod -aG sudo $user
echo "root:$password" | chpasswd
echo "$user:$password" | chpasswd
reboot