#!/bin/bash

usage() { echo "Usage: $0 -a <app name> " 1>&2; exit 1; }

while getopts "a:" o; do
    case "${o}" in
        a)
            a=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${a}" ]; then
    usage
fi

podman run --rm --name patmos-development-container -v /dev/ttyUSB0:/dev/ttyUSB0 -v /dev/usbblaster/:/dev/usbblaster/ -v ./patmos:/opt/t-crest/patmos --network host --privileged \
	--workdir /opt/t-crest/patmos -t -i --group-add keep-groups docker.io/lehrchristoph/patmos-dev-container:v1 bash -lc "make BOOTAPP=bootable-bootloader tools gen synth app APP=${a} comp config download"
