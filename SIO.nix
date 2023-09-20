let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "SIO";
    version = "v00-01";

    src = pkgs.fetchgit {
      url = "https://github.com/iLCSoft/SIO";
      rev = "89ad15cecbcc366880ec8e90e83658a260c3160d";
      sha256 = "sha256-MlqJOoMSRuYeG+jl8DFgcNnpEyeRgDCK2JlN9pOqBWA=";
    };

    buildInputs = hep.core pkgs;
    nativeBuildInputs = hep.wrappers pkgs;
}