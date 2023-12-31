let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "podio";
    version = "v00-13";

    src = pkgs.fetchgit {
      url = "https://github.com/AIDASoft/podio";
      rev = "cf3d239cbc4932e2b1d7ee42bcbef55ee869b3c1";
      sha256 = "sha256-8yAqB2Ltjo6alChFXjHlXmpatPj/fJkM6Q0svK/Rh24=";
    };

    buildInputs = hep.core pkgs;
    nativeBuildInputs = hep.wrappers pkgs;
}