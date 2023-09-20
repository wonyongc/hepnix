let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "evtgen";
    version = "2.0.0";

    src = pkgs.fetchgit {
      url = "https://gitlab.cern.ch/evtgen/evtgen";
      rev = "23c973a27630e7aca86d69eecb6f91c2f49d9767";
      sha256 = "sha256-MlqJOoMSRuYeG+jl8DFgcNnpEyeRgDCK2JlN9pOqBWA=";
    };

    buildInputs = hep.core pkgs ++ [ podio edm4hep VecCore VecGeom vdt SIO LCIO geant4 dd4hep ];
    nativeBuildInputs = hep.wrappers pkgs;

    cmakeFlags = [
        "-DEVTGEN_PYTHIA=ON"
    ];
}