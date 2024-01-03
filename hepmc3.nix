let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "hepmc3";
    version = "3.2.5";

    src = pkgs.fetchgit {
      url = "https://gitlab.cern.ch/hepmc/HepMC3";
      rev = "c524bfde132d1778b16fa2967388ebfa0e1b83bc";
      sha256 = "sha256-Mjudeb942c9LBiZBX+lCKvk5JKaVUctVKOu2Aq49JXk=";
    };

    buildInputs = hep.core pkgs ++ (with pkgs; [ AIDA podio edm4hep VecCore VecGeom vdt SIO LCIO evtgen hepPDT ]);
    nativeBuildInputs = hep.wrappers pkgs;

    cmakeFlags = [
        "-DCMAKE_CXX_STANDARD=17"
    ];
}
