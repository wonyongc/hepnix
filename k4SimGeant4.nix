let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "k4SimGeant4";
    version = "v0.1.0pre06";

    src = pkgs.fetchgit {
      url = "https://github.com/wonyongc/k4SimGeant4";
      rev = "3aa610b5c5089756e47a4cfe6d51784aaba86eb4";
      sha256 = "sha256-bkigtgSYGO3l00k1BGzjXuyKhCi+jvmsO13SHvQ68K4=";
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

}