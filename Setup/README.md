Setup
=====
This folder contains help guidelines and scripts to help with installing Xilinx ISE

### Windows

Follow [Install_Win.pdf](Install_Win.pdf)

### Linux

Follow [Install_Linux.pdf](Install_Linux.pdf)

If you need to install for other boards. Recomend checking out below.

Other Boards:

**Spartan**: Download and compile the xilinx libusb-drivers with `git clone git://git.zerfleddert.de/usb-driver && cd usb-driver && make`. After you compile add `export LD_PRELOAD=/$libusb_path/libusb-driver.so` to the setting64.sh or the script your using. Make sure you set the $libusb_path to the location where you have the usb-driver located.

Referances:
* [Platform Cable USB - Frequently Asked Questions (FAQs)](http://www.xilinx.com/support/answers/20429.html)
* [XILINX JTAG tools on Linux without proprietary kernel modules](http://rmdir.de/~michael/xilinx/)
* [Xilinx JTAG Linux](http://www.george-smart.co.uk/wiki/Xilinx_JTAG_Linux)

### Macintosh

Mac is currently not supported.
Recomend following the Linux setup if you are determined.

