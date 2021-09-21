#!/bin/bash

podman run --rm --name patmos-development-container -v /dev/ttyUSB0:/dev/ttyUSB0 -v /dev/usbblaster/:/dev/usbblaster/ -v ./patmos:/opt/t-crest/patmos --network host --privileged \
	--workdir /opt/t-crest/patmos -t -i --group-add keep-groups docker.io/lehrchristoph/patmos-dev-container:v1 bash -lc "make BOOTAPP=bootable-bootloader tools gen synth"
