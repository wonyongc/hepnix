let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "dd4hep";
    version = "v01-16-01";

    src = pkgs.fetchgit {
      url = "https://github.com/AIDASoft/DD4hep";
      rev = "4df3c2f6f26ca7fac19fbefebf3fdbf9b47de2c0";
      sha256 = "sha256-MlqJOoMSRuYeG+jl8DFgcNnpEyeRgDCK2JlN9pOqBWA=";
    };

    buildInputs = hep.core pkgs ++ [ podio edm4hep VecCore VecGeom vdt SIO LCIO geant4 ];
    nativeBuildInputs = hep.wrappers pkgs;

    cmakeFlags = [
        "-DDD4HEP_USE_XERCESC=ON   "
        "-DDD4HEP_USE_GEANT4=ON       "
        "-DDD4HEP_USE_LCIO=ON         "
        "-DDD4HEP_USE_GEANT4_UNITS=ON "
        "-DDD4HEP_USE_EDM4HEP=ON      "
        "-DDD4HEP_USE_HEPMC3=ON       "
        "-DDD4HEP_USE_TBB=ON          "
      ];

    prePhases = [ "sourcePhase" ];

    sourcePhase = ''
      source ${geant4}/bin/geant4.sh
    '';

}