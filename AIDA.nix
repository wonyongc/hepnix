let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    name = "AIDA";

    src = pkgs.fetchgit {
      url = "https://github.com/wonyongc/AIDA";
      rev = "35c5cf62aea735ac4e7176da4253b9936164a164";
      sha256 = "sha256-6sWsSxJBsA6MNyLkQHmAQvKLStnpXRhz4WrQIaQZ5cU=";
    };

    buildInputs = hep.core pkgs;
    nativeBuildInputs = hep.wrappers pkgs;

    configurePhase = ''
    source "$stdenv"/setup
    mkdir $out

    '';

    buildPhase = ''

    cp --recursive "$src"/src/ $out

    '';

    installPhase = ''

    '';
}