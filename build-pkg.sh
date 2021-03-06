#!/bin/bash

# Build deb or rpm packages for honeyaws.
set -e

function usage() {
    echo "Usage: build-pkg.sh -v <version> -t <package_type>"
    exit 2
}

while getopts "v:t:" opt; do
    case "$opt" in
    v)
        version=$OPTARG
        ;;
    t)
        pkg_type=$OPTARG
        ;;
    esac
done

if [ -z "$version" ] || [ -z "$pkg_type" ]; then
    usage
fi

fpm -s dir -n honeyaws \
    -m "Honeycomb <team@honeycomb.io>" \
    -p $GOPATH/bin \
    -v $version \
    -t $pkg_type \
    --pre-install=./preinstall \
    $GOPATH/bin/honeyelb=/usr/bin/honeyelb \
    $GOPATH/bin/honeycloudfront=/usr/bin/honeycloudfront \
    $GOPATH/bin/honeycloudtrail=/usr/bin/honeycloudtrail \
    $GOPATH/bin/honeyalb=/usr/bin/honeyalb \
    ./service/honeycloudfront.upstart=/etc/init/honeycloudfront.conf \
    ./service/honeycloudfront.service=/lib/systemd/system/honeycloudfront.service \
    ./service/honeyelb.upstart=/etc/init/honeyelb.conf \
    ./service/honeyelb.service=/lib/systemd/system/honeyelb.service \
    ./service/honeycloudtrail.upstart=/etc/init/honeycloudtrail.conf \
    ./service/honeycloudtrail.service=/lib/systemd/system/honeycloudtrail.service \
    ./service/honeyalb.upstart=/etc/init/honeyalb.conf \
    ./service/honeyalb.service=/lib/systemd/system/honeyalb.service
