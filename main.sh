# Clone Upstream
git clone https://gitlab.freedesktop.org/pipewire/pipewire.git -b 0.3.71
cp -rvf ./debian ./pipewire/
cd ./pipewire

for i in ../patches/*.patch; do patch -Np1 -i $i ;done

LOGNAME=root dh_make --createorig -y -l -p pipewire_0.3.71

# Get build deps
apt-get build-dep ./ -y

# Build package
dpkg-buildpackage --no-sign

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
