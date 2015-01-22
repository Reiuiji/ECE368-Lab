#!/bin/bash
#
# Xilinx icon installer/updater
# 
# Will populate the system with xilinx application icon
#
#################################################

APPLOC="/usr/share/applications"

RootCheck(){
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi
}

install() {
RootCheck
XilinxPath=`realpath $1`

#determine 64/32 bit
if [ $(uname -m) = "x86_64" ]
then
	B="64"
else
	B="32"
fi

echo "Installing application icons"
cat <<EOF > $APPLOC/ise.desktop

#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Name=Xilinx ISE
Exec=sh -c "export LANG=en_US.UTF-8 && source $XilinxPath/ISE_DS/settings$B.sh && ise"
Icon=$XilinxPath/ISE_DS/ISE/data/images/pn-ise.png
Categories=Development;
Comment=Xilinx ISE


EOF

cat <<EOF > $APPLOC/xps.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Name=Xilinx PS
Exec=sh -c "export LANG=en_US.UTF-8 && source $XilinxPath/ISE_DS/settings$B.sh && xps"
Icon=$XilinxPath/ISE_DS/EDK/data/images/ps_platform_studio.ico
Categories=Development;
Comment=Xilinx Platform Studio
EOF
echo "Installation Complete"
exit 0
}

remove() {
echo "Removing application icons"
[[ -f "$APPLOC/ise.desktop" ]] && rm $APPLOC/ise.desktop
[[ -f "$APPLOC/xps.desktop" ]] && rm $APPLOC/xps.desktop
echo "Removing Complete"
exit 0
}

usage() {
echo "Usage $0 [install/remove] [xilinx installed Dir]"
echo "Example $0 install /opt/Xilinx/14.7/"
echo "        $0 remove"
exit 1
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
