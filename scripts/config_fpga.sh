#!/bin/bash

usage() { echo "Usage: $0 -p <patmos directory> -j <jtag programmer>" 1>&2; exit 1; }

while getopts "j:p:" o; do
    case "${o}" in
		j)
			j=${OPTARG}
			;;
		p)
			p=${OPTARG}
			;;
		*)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${j}" ] || [ -z "${p}" ]; then
    usage
fi

podman run --rm --name patmos-development-container -v ${j}:/dev/jtag --network host --privileged \
	-v ${p}:/opt/t-crest/patmos  --workdir /opt/t-crest/patmos -t -i --group-add keep-groups \
	docker.io/lehrchristoph/patmos-dev-container:v1 bash -lc "make config"
