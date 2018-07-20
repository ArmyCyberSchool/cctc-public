#!/bin/bash
echo 127.0.0.1 $(hostname) >> /etc/hosts
echo 52.247.160.149 git.cybbh.space >> /etc/hosts
sed -i's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
export DEBIAN_FRONTEND=noninteractive
echo "deb http://deb.debian.org/debian jessie-backports main contrib non-free" >> /etc/apt/sources.list
apt-get update
apt-get -y upgrade
pkg_array=({xrdp,tigervnc-standalone-server,libssl1.0.0,libqt5webkit5,libqt5scripttools5,locate,netcat,dnsutils,curl,tmux,lsof,ftp,telnet,wireshark,tcpdump,p0f,scapy,nmap,proxychains,pv,nginx,proftpd,gdebi,install,ethtool,git,make,gcc,flex,bison,build-essential,checkinstall,libpcap-dev,libnet1-dev,libpcre3-dev,libnetfilter-queue-dev,iptables-dev,libdumbnet-dev,zlib1g-dev,gvfs-bin,python-pip})
for x in ${pkg_array[@]}; do apt-get install -y $x; done
# ----- Installs atom to work with python language
wget https://atom.io/download/deb
dpk -i deb
python -m pip install 'python-language-server[all]'
apm install atom-ide-ui ide-python
rm deb
# ----- Makes rdp work with VNC by default
cd /etc/xrdp
cat <<EOF | sudo patch -p1
--- a/xrdp.ini     2017-06-19 14:05:53.290490260 +0900
+++ b/xrdp.ini  2017-06-19 14:11:17.788557402 +0900
@@ -147,15 +147,6 @@ tcutils=true
 ; Session types
 ;

-[Xorg]
-name=Xorg
-lib=libxup.so
-username=ask
-password=ask
-ip=127.0.0.1
-port=-1
-code=20
-
 [Xvnc]
 name=Xvnc
 lib=libvnc.so
@@ -166,6 +157,15 @@ port=-1
 #xserverbpp=24
 #delay_ms=2000

+[Xorg]
+name=Xorg
+lib=libxup.so
+username=ask
+password=ask
+ip=127.0.0.1
+port=-1
+code=20
+
 [console]
 name=console
 lib=libvnc.so
EOF
sudo systemctl restart xrdp

mkdir /usr/share/CCTC
chmod 777 /usr/share/CCTC
cd /usr/share/CCTC
wget https://archive.org/download/pt711/PacketTracer7.1.1ForLinux64Bit.tar
tar xvf PacketTracer7.1.1ForLinux64Bit.tar
rm install
cat <<EOF > install.sh
#!/bin/bash

# Thanks to Brent C. for updating this install script to make it install without prompts.
# Thanks to Paul Fedele for providing script to check/download 32-bit library on a 64-bit machine
echo
echo "Welcome to Cisco Packet Tracer 7.1.1 Installation"
echo
installer ()
{
SDIR=`dirname $_`

echo "Packet Tracer will now be installed in the default location [/opt/pt]"

IDIR="/opt/pt"

if [ -e \$IDIR ]; then
sudo rm -rf \$IDIR
fi

QIDIR=\${IDIR//\//\\\\\/}

echo "Installing into \$IDIR"

if mkdir \$IDIR > /dev/null 2>&1; then
if cp -r \$SDIR/* \$IDIR; then
echo "Copied all files successfully to \$IDIR"
fi

sh -c "sed s/III/\$QIDIR/ \$SDIR/tpl.packettracer > \$IDIR/packettracer"
chmod a+x \$IDIR/packettracer
sh -c "sed s/III/\$QIDIR/ \$SDIR/tpl.linguist > \$IDIR/linguist"
chmod a+x \$IDIR/linguist

if touch /usr/share/applications/pt7.desktop > /dev/null 2>&1; then
echo -e "[Desktop Entry]\nExec=PacketTracer7\nIcon=pt7\nType=Application\nTerminal=false\nName=Packet Tracer 7.1" | tee /usr/share/applications/pt7.desktop > /dev/null
rm -f /usr/share/icons/hicolor/48x48/apps/pt7.png
gtk-update-icon-cache -f -q /usr/share/icons/hicolor
sleep 10
cp $SDIR/art/app.png /usr/share/icons/hicolor/48x48/apps/pt7.png
gtk-update-icon-cache -f -q /usr/share/icons/hicolor
fi

else
echo
if sudo mkdir \$IDIR; then
echo "Installing into \$IDIR"
if sudo cp -r \$SDIR/* \$IDIR; then
echo "Copied all files successfully to \$IDIR"
else
echo
echo "Not able to copy files to \$IDIR"
echo "Exiting installation"
exit
fi
sudo sh -c "sed s/III/\$QIDIR/ \$SDIR/tpl.packettracer > \$IDIR/packettracer"
sudo chmod a+x \$IDIR/packettracer
sudo sh -c "sed s/III/\$QIDIR/ \$SDIR/tpl.linguist > \$IDIR/linguist"
sudo chmod a+x \$IDIR/linguist

if sudo touch /usr/share/applications/pt7.desktop; then
echo -e "[Desktop Entry]\nExec=PacketTracer7\nIcon=pt7\nType=Application\nTerminal=false\nName=Packet Tracer 7.1" | sudo tee /usr/share/applications/pt7.desktop > /dev/null
sudo rm -f /usr/share/icons/hicolor/48x48/apps/pt7.png
sudo gtk-update-icon-cache -f -q /usr/share/icons/hicolor
sleep 10
sudo cp \$SDIR/art/app.png /usr/share/icons/hicolor/48x48/apps/pt7.png
sudo gtk-update-icon-cache -f -q /usr/share/icons/hicolor
fi

else
echo
echo "Not able to gain root access with sudo"
echo "Exiting installation"
exit
fi
fi

echo
echo
sudo ln -sf \$IDIR/packettracer /usr/local/bin/packettracer
echo "Type \"packettracer\" in a terminal to start Cisco Packet Tracer"

# add the environment var PT7HOME
sudo sh set_ptenv.sh $IDIR
sudo sh set_qtenv.sh

echo
echo "Cisco Packet Tracer 7.1.1 installed successfully"
echo "Please restart you computer for the Packet Tracer settings to take effect"
}
installer
exit 0
EOF
chmod +x install.sh
./install.sh
cat <<EOF > packettracer
#!/bin/bash                 
echo "Starting Packet Tracer 7.1.1"                 
PTDIR=/opt/pt
#export LD_LIBRARY_PATH=\$PTDIR/lib
pushd \$PTDIR/bin > /dev/null
./PacketTracer7 "\$@" > /dev/null 2>&1 &
popd > /dev/null                 
EOF
sudo chmod +x packettracer
sudo cp packettracer /usr/local/bin/packettracer
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
/sbin/ethtool -K eth0 tx off sg off tso off
EOF
chmod +x /etc/network/if-up.d/tcpoffload
cd /etc/network/if-up.d/
./tcpoffload
cd /
echo "CREATE USER"
useradd $user -m -U -s /bin/bash
usermod -aG sudo $user
echo 'root:$password' | chpasswd
echo '$user:$password' | chpasswd
reboot