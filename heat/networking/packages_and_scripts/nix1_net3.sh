#!/bin/bash            
echo 127.0.0.1 $(hostname) >> /etc/hosts
echo 52.247.160.149 git.cybbh.space >> /etc/hosts
apt-get -y update
apt-get -y upgrade
pkg_array=({locate,dnsutils,lsof,aptitude,ftp,auditd,xinetd,telnetd,samba,git,zip,unzip,figlet,sshpass,hexedit,tree,apache2,gcc,tcc,build-essential,libreadline-dev,libssl-dev,libpq5,libpq-dev,libreadline5,libsqlite3-dev,libpcap-dev,git-core,autoconf,postgresql,pgadmin3,curl,zlib1g-dev,libxml2-dev,libxslt1-dev,libyaml-dev,nmap,python-setuptools,python-dev,hydra,hydra-gtk,john,xrdp,netcat,firefox,figlet,lolcat,ubuntu_desktop,nginx,proftpd,ethtool,ruby,ruby-dev,gem,bundler,qemu})
for x in ${pkg_array[@]}; do apt-get install -y ${x}; done
gem install lolcat bundler
updatedb
mandb
mkdir /usr/share/class

# ----- GRABS PE BINARIES <ENSURE URL IS CURRENT>
wget -r -l 1 -nH -nd -R "index.html*","*.gif","*.pyc","banner.*" 10.50.20.181/linux/ -P /usr/share/class/
wget 10.50.20.181/linux/check.pyc -O /usr/share/misc/check.pyc
wget 10.50.20.181/linux/banner.sh -O /usr/share/misc/banner.sh
cat > /usr/share/misc/check_script.sh << "__EOF__"
#!/bin/bash
/usr/bin/env python /usr/share/misc/check.pyc
__EOF__
echo 'alias check="/usr/share/misc/check_script.sh"' >> /etc/bash.bashrc
chmod +x /usr/share/class/*
chmod +x /usr/share/misc/{check.pyc,banner.sh,check_script.sh}
    
# ----- ENABLES SSH
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart ssh
            
# ----- ENABLES TELNET
cat > /etc/xinetd.d/telnet <<"__TELNET__"
# default: on
# description: The telnet server serves telnet sessions; it uses
# unencrypted username/password pairs for authentication.
service telnet
{
disable = no
flags = REUSE
socket_type = stream
wait = no
user = root
server = /usr/sbin/in.telnetd
log_on_failure += USERID
}
__TELNET__
for x in {0..9}; do echo "pts/$x" >> /etc/securetty ; done
systemctl restart xinetd.service

# ----- INSTALLS LOGGING RULES INTO /etc/rsyslog.conf <not default in UBUNTU>
cat > /tmp/log_rules.txt <<"__LOGS__"

###############
#### RULES ####
###############
#
# First some standard log files.  Log by facility.
#
auth,authpriv.*			/var/log/auth.log
*.*;auth,authpriv.none	-/var/log/syslog
#cron.*				    /var/log/cron.log
daemon.*			    -/var/log/daemon.log
kern.*				    -/var/log/kern.log
lpr.*				    -/var/log/lpr.log
mail.*				    -/var/log/mail.log
user.*				    -/var/log/user.log

__LOGS__
sed '/$IncludeConfig \/etc\/rsyslog.d\/\*.conf/r /tmp/log_rules.txt' -i /etc/rsyslog.conf
systemctl restart rsyslog.service

useradd $user -m -U -s /bin/bash
useradd -m zeus -U -s /bin/bash
usermod -aG sudo $user
usermod -aG sudo zeus
echo "root:$password" | chpasswd
echo "$user:$password" | chpasswd
echo "zeus:PassWord1234" | chpasswd

# ----- EXPLOITATION TOOLS INSTALL
easy_install pip
pip install pefile capstone
git clone https://github.com/g0tmi1k/exe2hex.git /usr/share/exe2hex
git clone https://github.com/1aN0rmus/TekDefense-Automater.git /usr/share/automater
git clone https://github.com/secretsquirrel/the-backdoor-factory.git /usr/share/backdoor
git clone https://github.com/Veil-Framework/Veil.git /usr/share/veil
/usr/share/Veil/setup/setup.sh -c
git clone https://github.com/danielmiessler/SecLists.git /usr/share/seclists

# -----NETWORKING CONFIGS
git clone http://github.com/iagox86/dnscat2.git
echo "INSTALLS COMPLETE"
cd dnscat2/server
bundle install
echo "SETUP WEBPAGE"
echo "<html><h1>Page</h1>This is a blank webpage on H3.</html>" >> /var/www/html/index.html            
sed -i '/# Use this to jail/a \
DefaultRoot         /srv/ftp' /etc/proftpd/proftpd.conf 
echo "SETUP FTP FILE"
service proftpd restart
touch /srv/ftp/ftp.txt
echo "This is a file hosted via ftp and accessible via anonymous login on H3." >> /srv/ftp/ftp.txt
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
