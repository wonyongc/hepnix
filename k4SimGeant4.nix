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
      sha256 = "sha256-jm9NujXd2B+lVFAd7xmwG3IiwSXo2xAAbaxtuk0XsCo=";
    };

    buildInputs = hep.core pkgs ++ (with pkgs; [ AIDA podio edm4hep VecCore VecGeom vdt SIO LCIO mygeant4 dd4hep evtgen hepPDT gaudi k4FWCore ]);
    nativeBuildInputs = hep.wrappers pkgs;

    cmakeFlags = [
        "-DCMAKE_CXX_STANDARD=17"
    ];

    prePhases = [ "sourcePhase" ];

    sourcePhase = ''
    source ${pkgs.mygeant4}/bin/geant4.sh
    source ${pkgs.dd4hep}/bin/thisdd4hep.sh
    '';

    configurePhase = ''
    source "$stdenv"/setup
    mkdir $out

    '';

    buildPhase = ''

    cp --recursive "$src"/src/ $out

    '';

    installPhase = ''

    '';

}