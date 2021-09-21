#!/bin/bash
############################################################
# Setup up container and environment
###########################################################

usage() { echo "Usage: $0 -p <patmos directory> -u (udev and user setup)" 1>&2; exit 1; }

while getopts "p:u" o; do
    case "${o}" in
        p)
			p=${OPTARG}
			;;
		u)
			u=$TRUE
			;;
		*)
			usage
			;;
    esac
done
shift $((OPTIND-1))

if [ -z "${p}" ] ; then
    usage
fi

# Setup udev rules
if $u ; then
	script_dir=$(dirname $0)
	sudo cp $script_dir/../misc/50-usbblaster.rules /etc/udev/rules.d/
	sudo udevadm control --reload
	sudo udevadm trigger

	# Add user to dialout and tty group
	sudo usermod -a -G tty $USER
	sudo usermod -a -G dialout $USER
fi

# Clone Patmos repository for development
git clone https://github.com/t-crest/patmos.git ${p}

# Download image
echo "Pulling image, this may take some minutes, get a coffee"
podman pull docker.io/lehrchristoph/patmos-dev-container:v1

# Initial Build of Patmos Microprocessor
echo "Building patmos Microprocessor"
podman run --rm --name patmos-development-container -v ${p}:/opt/t-crest/patmos --workdir /opt/t-crest/patmos \
	--network host --privileged -t -i --group-add keep-groups docker.io/lehrchristoph/patmos-dev-container:v1 \
	 bash -lc "make BOOTAPP=bootable-bootloader tools gen synth"

# -v /dev/ttyUSB0:/dev/ttyUSB0 -v /dev/usbblaster:/dev/usbblaster


