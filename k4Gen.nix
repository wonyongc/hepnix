let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "k4Gen";
    version = "v0.1pre04";

    src = pkgs.fetchgit {
      url = "https://github.com/HEP-FCC/k4Gen";
      rev = "b7c735e401298a8c72915819dc0404a83f46a0fe";
      sha256 = "sha256-MlqJOoMSRuYeG+jl8DFgcNnpEyeRgDCK2JlN9pOqBWA=";
    };

    buildInputs = hep.core pkgs ++ [ podio edm4hep VecCore VecGeom vdt SIO LCIO geant4 dd4hep evtgen gaudi K4FWCore k4SimGeant4 ];
    nativeBuildInputs = hep.wrappers pkgs;

}