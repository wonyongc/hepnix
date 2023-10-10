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
      sha256 = "sha256-kwgblltpDoF7bHkoRMA68P3ZotEZnHICAWiqU/kv/Ok=";
    };

    buildInputs = hep.core pkgs ++ (with pkgs; [ AIDA podio edm4hep VecCore VecGeom vdt SIO LCIO mygeant4 dd4hep evtgen hepPDT gaudi ]);
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