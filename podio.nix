let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "podio";
    version = "v00-14-01";

    src = pkgs.fetchgit {
      url = "https://github.com/AIDASoft/podio";
      rev = "694d5b4db084e515f1f2b2b08146849cc53b5f9a";
      sha256 = "sha256-fImAbdpBAscr/12p4W7uI2xL3uNBQDBR7U1ilkD6rjQ=";
    };

    buildInputs = hep.core pkgs;
    nativeBuildInputs = hep.wrappers pkgs;
}