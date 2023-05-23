# Add dependent repositories
sudo dpkg --add-architecture i386
wget -q -O - https://ppa.pika-os.com/key.gpg | sudo apt-key add -
add-apt-repository https://ppa.pika-os.com
add-apt-repository ppa:pikaos/pika
add-apt-repository ppa:kubuntu-ppa/backports
# Clone Upstream
git clone https://gitlab.freedesktop.org/pipewire/pipewire.git -b 0.3.71
cp -rvf ./debian ./pipewire/
cd ./pipewire

for i in ../patches/*.patch; do patch -Np1 -i $i ;done

apt-get install -y pbuilder debootstrap devscripts debhelper sbuild debhelper ubuntu-dev-tools piuparts dh-make

LOGNAME=root dh_make --createorig -y -l -p pipewire_0.3.71

# Get build deps
ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
apt-get build-dep -y ./
debuild -S -uc -us
cd ../

apt install -y debian-archive-keyring
cp -rvf ./pbuilderrc /etc/pbuilderrc
mkdir -p /var/cache/pbuilder/hook.d/
cp -rvf ./hooks/* /var/cache/pbuilder/hook.d/
rm -rf /var/cache/apt/
mkdir -p /pbuilder-results
DIST=lunar ARCH=i386 pbuilder create --distribution lunar --architecture i386 --debootstrapopts --include=ca-certificates
echo 'starting build'
DIST=lunar ARCH=i386 pbuilder build ./*.dsc --distribution lunar --architecture i386 --debootstrapopts --include=ca-certificates

# Move the debs to output
mkdir -p ./output
mv /var/cache/pbuilder/result/*.deb ./output/ || sudo mv ../*.deb ./output/
