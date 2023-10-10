let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "hepPDT";
    version = "2.06.01";

    src = pkgs.fetchgit {
      url = "https://github.com/wonyongc/HepPDT";
      rev = "bb0349bb0ef04e9c4d6813a498801c8f432e5f24";
      sha256 = "sha256-KQ7EX6xRmiXVW8c9FJgVxNFyRurZhtuSJzZGnzuuy1A=";
    };

    buildInputs = hep.core pkgs;
    nativeBuildInputs = hep.wrappers pkgs;

    configurePhase = ''
      source "$stdenv"/setup
      if [ ! -d "build" ]; then
        mkdir build
      fi
      cd build
      $src/configure --prefix=$out
    '';

    buildPhase = ''
      make -j24
    '';

    installPhase = ''
      make install
    '';

}