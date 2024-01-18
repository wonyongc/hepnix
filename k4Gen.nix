let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "k4Gen";
    version = "v0.1pre07";

    src = pkgs.fetchgit {
      url = "https://github.com/HEP-FCC/k4Gen";
      rev = "e2eef998d27d09cee2ec670fc5756b1c9d1f4968";
      sha256 = "sha256-4hDSqmCqM0IOnmxEla2SY6ggw6pWEiJhXSVy2PWnyqI=";
    };

    buildInputs = hep.core pkgs ++ (with pkgs; [ AIDA podio edm4hep VecCore VecGeom vdt SIO LCIO mygeant4 dd4hep evtgen hepmc3 hepPDT gaudi k4FWCore k4SimGeant4 ]);
    nativeBuildInputs = hep.wrappers pkgs;

    cmakeFlags = [
        "-DCMAKE_CXX_STANDARD=17"
        "-DHEPMC_INCLUDE_DIR=${pkgs.hepmc3}/include/HepMC3"
        "-DHEPMC_HepMC_LIBRARY=${pkgs.hepmc3}/lib/libHepMC3.so"

    ];

    prePhases = [ "sourcePhase" ];

    sourcePhase = ''
    source ${pkgs.mygeant4}/bin/geant4.sh
    source ${pkgs.dd4hep}/bin/thisdd4hep.sh

    '';
}