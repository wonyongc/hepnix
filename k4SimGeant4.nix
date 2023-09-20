let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "k4SimGeant4";
    version = "v0.1.0pre06";

    src = pkgs.fetchgit {
      url = "https://github.com/HEP-FCC/k4SimGeant4";
      rev = "d476bee85274d8ab6c93113efba1e5aad8ab8942";
      sha256 = "sha256-MlqJOoMSRuYeG+jl8DFgcNnpEyeRgDCK2JlN9pOqBWA=";
    };

    buildInputs = hep.core pkgs ++ [ podio edm4hep VecCore VecGeom vdt SIO LCIO geant4 dd4hep evtgen gaudi K4FWCore ];
    nativeBuildInputs = hep.wrappers pkgs;

    cmakeFlags = [
        "-DCMAKE_CXX_STANDARD=17"
      ];

    prePhases = [ "sourcePhase" ];

    sourcePhase = ''
    source ${geant4}/bin/geant4.sh
    source ${DD4hep}/bin/thisdd4hep.sh
    '';

}