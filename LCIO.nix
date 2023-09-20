let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "LCIO";
    version = "v02-16-01";

    src = pkgs.fetchgit {
      url = "https://github.com/iLCSoft/LCIO";
      rev = "8f9e86b93b7d5d83221fabb872ed7e82f1638476";
      sha256 = "sha256-MlqJOoMSRuYeG+jl8DFgcNnpEyeRgDCK2JlN9pOqBWA=";
    };

    buildInputs = hep.core pkgs ++ [ podio edm4hep ];
    nativeBuildInputs = hep.wrappers pkgs;
}