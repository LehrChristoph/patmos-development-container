#!/bin/bash

usage() { echo "Usage: $0 -p <patmos directory> -a <app name>" 1>&2; exit 1; }

while getopts "a:p:" o; do
    case "${o}" in
        a)
			a=${OPTARG}
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

if [ -z "${a}" ] || [ -z "${p}" ]; then
    usage
fi

podman run --rm --name patmos-development-container --network host --privileged \
	-v ${p}:/opt/t-crest/patmos  --workdir /opt/t-crest/patmos -t -i \
	docker.io/lehrchristoph/patmos-dev-container:v1 bash -lc "make APP=${a} comp"
