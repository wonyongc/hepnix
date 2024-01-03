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
      sha256 = "sha256-Mjudeb942c9LBiZBX+lCKvk5JKaVUctVKOu2Aq49JXk=";
    };

    buildInputs = hep.core pkgs ++ (with pkgs; [ AIDA podio edm4hep VecCore VecGeom vdt SIO LCIO mygeant4 dd4hep evtgen hepPDT gaudi k4FWCore k4SimGeant4 ]);
    nativeBuildInputs = hep.wrappers pkgs;

    cmakeFlags = [
        "-DCMAKE_CXX_STANDARD=17"
    ];

    prePhases = [ "sourcePhase" ];

    sourcePhase = ''
    source ${pkgs.mygeant4}/bin/geant4.sh
    source ${pkgs.dd4hep}/bin/thisdd4hep.sh

    '';
}