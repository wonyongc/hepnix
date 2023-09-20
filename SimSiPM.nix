let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "SimSiPM";
    version = "v1.2.3-beta";

    src = pkgs.fetchgit {
      url = "https://github.com/EdoPro98/SimSiPM";
      rev = "9361d3fe16abfac6d57ecc61d778db219a32c764";
      sha256 = "sha256-MlqJOoMSRuYeG+jl8DFgcNnpEyeRgDCK2JlN9pOqBWA=";
    };

    buildInputs = hep.core pkgs ++ [ podio edm4hep VecCore VecGeom vdt SIO LCIO geant4 dd4hep evtgen gaudi K4FWCore k4SimGeant4 k4Gen ];
    nativeBuildInputs = hep.wrappers pkgs;


}