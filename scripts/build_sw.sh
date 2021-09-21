#!/bin/bash

usage() { echo "Usage: $0 -a <app name> -j <jtag programmer> -s <serial interface> " 1>&2; exit 1; }

while getopts "a:j:s:" o; do
    case "${o}" in
        a)
		a=${OPTARG}
            	;;
	j)
		j=${OPTARG}
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

if [ -z "${a}" ] || [ -z "${j}" ] || [ -z "${s}" ]; then
    usage
fi

podman run --rm --name patmos-development-container -v ${s}:/dev/ttyUSB0 -v ${j}:/dev/jtag -v ./patmos:/opt/t-crest/patmos --network host --privileged \
	--workdir /opt/t-crest/patmos -t -i --group-add keep-groups docker.io/lehrchristoph/patmos-dev-container:v1 bash -lc "make APP=${a} tools comp config download"
