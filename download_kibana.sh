#!/usr/bin/env bash

version="$1"

if [ -z $version ]; then
    echo "You must specify a Kibana version at positional argument!"
    exit 666
fi

# TODO : parameterize version
wget "https://artifacts.elastic.co/downloads/kibana/kibana-${version}-linux-x86_64.tar.gz"

# get sha512 checksum (make sure there's no newline at the end of the file)
echo -n "$(sha512sum kibana-${version}-linux-x86_64.tar.gz)" > src.sha512

wget "https://artifacts.elastic.co/downloads/kibana/kibana-${version}-linux-x86_64.tar.gz.sha512"
mv kibana-${version}-linux-x86_64.tar.gz.sha512 truth.sha512
checksum_diff=$(diff src.sha512 truth.sha512)

# do not extract tarball if checksums differ!
if [[ -z "$d" ]]; then
    echo "extracting kibana..."
    tar -xf kibana-${version}-linux-x86_64.tar.gz
    mv kibana-${version}-linux-x86_64/ kibana

else
    echo "ERROR: checksums differ - extraction terminated"
fi

# cleanup
rm src.sha512 truth.sha512 kibana-${version}-linux-x86_64.tar.gz

exit 0
