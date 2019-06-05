#! /bin/bash

# Installation of basic build dependencies
## Debian / Ubuntu
apt update
apt-get install --no-install-recommends gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libc-ares-dev automake -y

# Installation of libsodium
export LIBSODIUM_VER=1.0.16
wget https://download.libsodium.org/libsodium/releases/libsodium-$LIBSODIUM_VER.tar.gz
tar xvf libsodium-$LIBSODIUM_VER.tar.gz
pushd libsodium-$LIBSODIUM_VER
./configure --prefix=/usr && make
make install
popd
ldconfig

# Installation of MbedTLS
export MBEDTLS_VER=2.6.0
wget https://tls.mbed.org/download/mbedtls-$MBEDTLS_VER-gpl.tgz
tar xvf mbedtls-$MBEDTLS_VER-gpl.tgz
pushd mbedtls-$MBEDTLS_VER
make SHARED=1 CFLAGS="-O2 -fPIC"
make DESTDIR=/usr install
popd
ldconfig

git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
git submodule update --init --recursive

# Start building
./autogen.sh && ./configure && make
make install

cd ..
mkdir -p /etc/shadowsocks
cp ss-libev /etc/init.d/
chmod +x /etc/init.d/ss-libev
update-rc.d /etc/init.d/ss-libev defaults

echo "Modefy config.json and then move it to /etc/shadowsocks/config.json"
echo "then run "/etc/init.d/ss-libev start" to start"

