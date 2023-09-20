let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "edm4hep";
    version = "v00-03";

    src = pkgs.fetchgit {
      url = "https://github.com/key4hep/EDM4hep";
      rev = "e17d47ab9f17f3a56fb90550d307275cacd93153";
      sha256 = "sha256-MlqJOoMSRuYeG+jl8DFgcNnpEyeRgDCK2JlN9pOqBWA=";
    };

    buildInputs = hep.core pkgs ++ [ podio ];
    nativeBuildInputs = hep.wrappers pkgs;
}