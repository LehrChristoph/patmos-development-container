#!/bin/bash
############################################################
# Setup up container and environment
###########################################################

# Setup udev rules
sudo cp ./50-usbblaster.rules /etc/udev/rules.d/
sudo udevadm control --reload
sudo udevadm trigger

# Add user to dialout and tty group
sudo usermod -a -G tty $USER
sudo usermod -a -G dialout $USER

# Clone Patmos repository for development
git clone https://github.com/t-crest/patmos.git patmos

# Download image
echo "Pulling image, this may take some minutes, get a coffee"
podman pull docker.io/lehrchristoph/patmos-dev-container:v1

# Finish preparation of patmos
#podman run --rm --name patmos-development-container -v ./patmos:/opt/t-crest/patmos --network host \
#        --workdir /opt/t-crest/patmos -t -i docker.io/lehrchristoph/patmos-dev-container:v1 bash -lc "\
#	cd /opt/t-crest/misc && \
#    	cp build.cfg.dist build.cfg && \
#    	sed -i "s/BUILDSH_TARGETS=\"gold llvm newlib compiler-rt pasim poseidon aegean\"/BUILDSH_TARGETS=\"patmos\"/" ./build.cfg && \
#	cd .. && ./misc/build.sh"

#	cp /opt/t-crest/patmos/tools/scripts/build/config_altera /opt/t-crest/local/bin && \
#	cp /opt/t-crest/patmos/tools/scripts/build/config_xilinx /opt/t-crest/local/bin && \
#	cp /opt/t-crest/patmos/tools/scripts/build/patserdow /opt/t-crest/local/bin && \
#	cp /opt/t-crest/patmos/tools/scripts/build/patex /opt/t-crest/local/bin"


# Initial Build of Patmos Microprocessor
echo "Building patmos Microprocessor"
podman run --rm --name patmos-development-container -v /dev/ttyUSB0:/dev/ttyUSB0 -v /dev/usbblaster/:/dev/usbblaster/ -v ./patmos:/opt/t-crest/patmos --network host --privileged \
	--workdir /opt/t-crest/patmos -t -i --group-add keep-groups docker.io/lehrchristoph/patmos-dev-container:v1 bash -lc "make BOOTAPP=bootable-bootloader tools gen synth"

	
#patmos-quartus_20.1 bash -lc "make BOOTAPP=bootable-bootloader APP=hello_puts gen synth config download" 
	

