#!/bin/bash

usage() { echo "Usage: $0 -p <patmos directory> -j <jtag programmer> -s <serial interface> " 1>&2; exit 1; }

while getopts "j:p:s:" o; do
    case "${o}" in
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

if  [ -z "${j}" ] || [ -z "${s}" ] || [ -z "${p}" ]; then
    usage
fi

podman run --rm -it --name patmos-development-container -v ${s}:/dev/ttyUSB0 -v ${j}:/dev/jtag --network host --privileged \
	-v ${p}:/opt/t-crest/patmos  --workdir /opt/t-crest/patmos --group-add keep-groups --ipc host \
	--ipc host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
	docker.io/lehrchristoph/patmos-dev-container:v1 
