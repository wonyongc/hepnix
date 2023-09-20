{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSUserEnv {
  name = "simple-x11-env";
  targetPkgs = pkgs: (with pkgs;
    [ udev
      libstdcxx5
      stdenv
      bash
      openssl
      util-linux
      libyaml
      protobuf
      gtk2
      unixtools.ifconfig
      unixtools.nettools
      unixtools.fdisk
      unixtools
      inetutils
      hwinfo
      toybox
      busybox
      pciutils
      lsscsi
      usbutils
      util-linux

      coreutils-full
      dmidecode
      boost
      ocl-icd
      opencl-headers
      opencl-clhpp
      libdrm
      pkg-config
      dpkg
      git
      coreutils
      ncurses5
      motif
      qt48Full
      rpcbind
      zlib
      glib
      freetype
      fontconfig
      libuuid
      nettools
      iproute2
      curl
      glib-networking
      libsoup
      firefox
      graphviz
      gcc
      unzip
    ]) ++ (with pkgs.xorg;
    [ libX11
      libXcursor
      libXrandr
      libSM
      libICE
      libXi
      libXft
      libxcb
      libXrender
      libXtst
      libXext
    ]);
  multiPkgs = null;

  runScript = "bash";


}).env