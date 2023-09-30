#! /bin/bash

# Clone Upstream
git clone https://gitlab.freedesktop.org/pipewire/pipewire.git -b 0.3.80
cp -rvf ./debian ./pipewire/
cd ./pipewire

for i in $(cat ../patches/series) ; do echo "Applying Patch: $i" && patch -Np1 -i ../patches/$i || echo "Applying Patch $i Failed!"; done

LOGNAME=root dh_make --createorig -y -l -p pipewire_0.3.80

# Get build deps
apt-get build-dep ./ -y

# Build package
dpkg-buildpackage --no-sign

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
