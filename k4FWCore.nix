let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "k4FWCore";
    version = "v01-00pre11";

    src = pkgs.fetchgit {
      url = "https://github.com/key4hep/k4FWCore";
      rev = "38d1f2347c36a85f75d84baff144395a553c6bbd";
      sha256 = "sha256-MlqJOoMSRuYeG+jl8DFgcNnpEyeRgDCK2JlN9pOqBWA=";
    };

    buildInputs = hep.core pkgs ++ [ podio edm4hep VecCore VecGeom vdt SIO LCIO geant4 dd4hep evtgen gaudi ];
    nativeBuildInputs = hep.wrappers pkgs;

    prePhases = [ "sourcePhase" ];

    sourcePhase = ''
    source ${geant4}/bin/geant4.sh
    '';
}