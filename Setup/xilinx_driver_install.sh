#!/bin/bash
#
# Xilinx driver installer
# 
# Installs:
#  *Xilinx development boards
#  *Digilent development boards
#
#################################################

#Init
RuleDir='/etc/udev/rules.d'
RuleDigilentName='52-digilent-usb.rules'
RuleUSBName='xusbdfwu.rules'

#Check for root
RootCheck(){
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi
}

#Install Depedecies for Xilinx
installdep() {

echo "Installing dependecies"

#Check package manager
DNF_CHECK=$(which dnf 2> /dev/null) #Fedora 23 and above
YUM_CHECK=$(which yum 2> /dev/null) #Redhat/Fedora/CentOS
APT_CHECK=$(which apt-get 2> /dev/null) #Debian/Ubuntu/Mint
PAC_CHECK=$(which pacman 2> /dev/null) #Arch
EMERGE_CHECK=$(which emerge 2> /dev/null) #Gentoo <3

if [[ ! -z $DNF_CHECK ]]; then
    dnf install libusb-devel fxload -y
elif [[ ! -z $YUM_CHECK ]]; then
    yum install libusb-devel fxload -y
elif [[ ! -z $APT_CHECK ]]; then
    apt-get install libusb-dev fxload -y
elif [[ ! -z $PAC_CHECK ]]; then
    pacman --needed -S libusb wget tar
    # fxload is not in the arch repo, get from the AUR
    aurinstall_fxload
elif [[ ! -z $EMERGE_CHECK ]]; then
    emerge -v libusb fxload
else
    echo "[ERROR]: Unknown package manager"
    exit 1;
fi

echo "Installing dependecies complete"
}

install() {
RootCheck
installdep

echo "Installing Xilinx drivers"

XilinxPath=`realpath $1`

#grab fxload installed location
fxloadPath=`whereis fxload | awk '{ print $2 }'`

#determine 64/32 bit
if [ $(uname -m) = "x86_64" ]
then
	lin="lin64"
else
	lin="lin"
fi

#write xilinx usb rules
cat <<EOF > $RuleDir/$RuleUSBName
#Xilinx usb rules
ATTR{idVendor}=="03fd", ATTR{idProduct}=="0008", MODE="666"
SUBSYSTEMS=="usb", ACTION=="add", ATTR{idVendor}=="03fd", ATTR{idProduct}=="0007", RUN+="$fxloadPath -v -t fx2 -I $XilinxPath/ISE_DS/ISE/bin/$lin/xusbdfwu.hex -D %N"
SUBSYSTEMS=="usb", ACTION=="add", ATTR{idVendor}=="03fd", ATTR{idProduct}=="0009", RUN+="$fxloadPath -v -t fx2 -I $XilinxPath/ISE_DS/ISE/bin/$lin/xusb_xup.hex -D %N"
SUBSYSTEMS=="usb", ACTION=="add", ATTR{idVendor}=="03fd", ATTR{idProduct}=="000d", RUN+="$fxloadPath -v -t fx2 -I $XilinxPath/ISE_DS/ISE/bin/$lin/xusb_emb.hex -D %N"
SUBSYSTEMS=="usb", ACTION=="add", ATTR{idVendor}=="03fd", ATTR{idProduct}=="000f", RUN+="$fxloadPath -v -t fx2 -I $XilinxPath/ISE_DS/ISE/bin/$lin/xusb_xlp.hex -D %N"
SUBSYSTEMS=="usb", ACTION=="add", ATTR{idVendor}=="03fd", ATTR{idProduct}=="0013", RUN+="$fxloadPath -v -t fx2 -I $XilinxPath/ISE_DS/ISE/bin/$lin/xusb_xp2.hex -D %N"
SUBSYSTEMS=="usb", ACTION=="add", ATTR{idVendor}=="03fd", ATTR{idProduct}=="0015", RUN+="$fxloadPath -v -t fx2 -I $XilinxPath/ISE_DS/ISE/bin/$lin/xusb_xse.hex -D %N"
EOF
echo ">> $RuleDir/$RuleUSBName"

#Install Digilent Rules
echo "Installing Digilent rules"

#can only install if in current dir of digilent. digilent script is reference based from there
cd $XilinxPath/ISE_DS/ISE/bin/$lin/digilent/

./install_digilent.sh

#This will fix digilent drivers so Impact can read a digilent device example:Nexys
mkdir -p $XilinxPath/ISE_DS/ISE/lib/$lin/plugins/Digilent/libCseDigilent
cd $XilinxPath/ISE_DS/ISE/bin/$lin/digilent/libCseDigilent_2.4.4-x86_64/$lin/14.1/libCseDigilent
cp libCseDigilent.{so,xml} $XilinxPath/ISE_DS/ISE/lib/$lin/plugins/Digilent/libCseDigilent
chmod -x $XilinxPath/ISE_DS/ISE/lib/$lin/plugins/Digilent/libCseDigilent/libCseDigilent.xml

#Update Xilinx bash settings
echo "Updating Xilinx setting scripts"
#Check one setting file to see if it was changed
SET_SETTING=$(cat $XilinxPath/ISE_DS/settings64.sh | grep QT)
if [[ -z $SET_SETTING ]]; then
    sed -i '2i\
unset QT_PLUGIN_PATH #prevent QT from crashing\
export XIL_IMPACT_USE_LIBUSB=1 #skip windrv6 and load directly ISE impact\
' $XilinxPath/ISE_DS/settings32.sh
    sed -i '2i\
unset QT_PLUGIN_PATH #prevent QT from crashing\
export XIL_IMPACT_USE_LIBUSB=1 #skip windrv6 and load directly ISE impact\
' $XilinxPath/ISE_DS/settings64.sh
    sed -i '2i\
unset QT_PLUGIN_PATH #prevent QT from crashing\
export XIL_IMPACT_USE_LIBUSB=1 #skip windrv6 and load directly ISE impact\
' $XilinxPath/ISE_DS/settings32.csh
    sed -i '2i\
unset QT_PLUGIN_PATH #prevent QT from crashing\
export XIL_IMPACT_USE_LIBUSB=1 #skip windrv6 and load directly ISE impact\
' $XilinxPath/ISE_DS/settings64.csh

else
    echo "Already setup the setting file, skipping"
fi

#reload udev rules
echo "Reloading rules"

SYSD_CHECK=$(which udevadm 2> /dev/null)

if [[ ! -z $SYSD_CHECK ]]; then
    udevadm control --reload
    udevadm trigger
else
    /etc/init.d/udev restart
fi

echo "Enter any user for usb access with the following command"
echo "gpasswd -a [USER] uucp"

echo "Xilinx install Complete"
exit 0
}

remove() {
echo "removing Xilinx drivers"
[[ -f "$RuleDir/$RuleUSBName" ]] && rm $RuleDir/$RuleUSBName
echo "Reloading rules"
udevadm control --reload
udevadm trigger
echo "Xilinx uninstall Complete"
exit 0
}

usage() {
	echo "Usage $0 [install/remove] [xilinx installed Dir]"
	echo "Example $0 install /opt/Xilinx/14.7/"
	echo "        $0 remove"
	exit 1

}

aurinstall_fxload() { 
  TMPDIR='/tmp/ywbuild'
  # Create directory nobody else would make
  echo "Creating temporary build directory..."
  mkdir -p $TMPDIR
  chgrp nobody $TMPDIR
  chmod g+ws $TMPDIR
  setfacl -m u::rwx,g::rwx $TMPDIR
  setfacl -d --set u::rwx,g::rwx,0::- $TMPDIR
  cd $TMPDIR

  # Get and install fxload from AUR
  echo "Installing fxload..."
  sudo -u nobody wget https://aur.archlinux.org/cgit/aur.git/snapshot/fxload.tar.gz
  sudo -u nobody tar -xvf fxload.tar.gz
  cd fxload
  sudo -u nobody makepkg
  pacman -U fxload*.tar.xz
  cd /root

  # Cleaning house
  rm -r $TMPDIR
  echo "Cleaning... fxload should be installed"

  # Making digilentusb hotplug script happy
  mkdir -p /etc/hotplug/usb
}

case $1 in
  install) 
	if [[ ( $# == 2 ) ]]
	then
		install $2 
	fi 
	;;
  remove) "$1" ;;
  *) usage ;;
esac
install $1
