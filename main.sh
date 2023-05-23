# Add dependent repositories
wget -q -O - https://ppa.pika-os.com/key.gpg | sudo apt-key add -
add-apt-repository https://ppa.pika-os.com
add-apt-repository ppa:pikaos/pika
add-apt-repository ppa:kubuntu-ppa/backports
# Clone Upstream
git clone https://gitlab.freedesktop.org/pipewire/pipewire.git -b 0.3.71
cp -rvf ./debian ./pipewire/
cd ./pipewire

for i in ../patches/*.patch; do patch -Np1 -i $i ;done

LOGNAME=root dh_make --createorig -y -l -p pipewire_0.3.71

# Get build deps
ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
apt-get build-dep ./ -y

# Build package
dpkg-buildpackage --no-sign

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
