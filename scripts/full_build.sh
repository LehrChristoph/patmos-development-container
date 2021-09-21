#!/bin/bash

usage() { echo "Usage: $0 -p <patmos directory> -a <app name> -j <jtag programmer> -s <serial interface> " 1>&2; exit 1; }

while getopts "a:j:p:s:" o; do
    case "${o}" in
        a)
			a=${OPTARG}
			;;
		j)
			j=${OPTARG}
			;;
		p)
			p=${OPTARG}
			;;
		s)
			s=${OPTARG}
			;;
		*)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${a}" ] || [ -z "${j}" ] || [ -z "${s}" ] || [ -z "${p}" ]; then
    usage
fi

podman run --rm --name patmos-development-container -v ${s}:/dev/ttyUSB0 -v ${j}:/dev/jtag --network host --privileged \
	-v ${p}:/opt/t-crest/patmos  --workdir /opt/t-crest/patmos -t -i --group-add keep-groups \
	docker.io/lehrchristoph/patmos-dev-container:v1 bash -lc "make BOOTAPP=bootable-bootloader APP=${a} tools gen synth config download"
