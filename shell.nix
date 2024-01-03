{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSUserEnv {
  name = "simple-x11-env";
  targetPkgs = pkgs: (with pkgs;
    [ 
alsa-lib
bash
bind
boost
busybox
coreutils
coreutils-full
cups
curl
dmidecode
dnsutils
dpkg
elfutils
firefox
fontconfig
freetype
gcc
git
glib
glib-networking
gomp
graphviz
gtk2
hwinfo
inetutils
iproute2
libdrm
libnsl
libstdcxx5
libuuid
libyaml
libsoup
libxcrypt
libxkbcommon
lsscsi
mesa
motif
ncurses5
nettools
inetutils
nss
ocl-icd
opencl-clhpp
opencl-headers
openssl
pciutils
pkg-config
protobuf
qt48Full
rpcbind
shared-mime-info
stdenv
toybox
udev
unixtools
unixtools.fdisk
unixtools.ifconfig
unixtools.nettools
usbutils
util-linux
util-linux
xdg-utils
xvfb-run
zlib

    ]) ++ (with pkgs.xorg;
    [ libX11
      libXcomposite
      libXdamage
      libXcursor
      libXrandr
      libXtst
      libSM
      libICE
      libXi
      libXft
      libxcb
      libXrender
      libXtst
      libXext
      xcbutilimage
      xcbutilkeysyms
      xcbutilrenderutil
      xcbutilwm
    ]);
  multiPkgs = null;

  runScript = "bash";


}).env