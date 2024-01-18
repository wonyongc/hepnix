let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "evtgen";
    version = "2.1.0";

    src = pkgs.fetchgit {
      url = "https://gitlab.cern.ch/evtgen/evtgen";
      rev = "abb51c5dc1a2c4ff8b879674b2a1ae8fe7d5ed18";
      sha256 = "sha256-KOqnyUjN41P6VYfWcry51T1aDpLP4CZbnoU9dJGTedY=";
    };

    buildInputs = hep.core pkgs ++ (with pkgs; [ podio edm4hep hepmc3 VecCore VecGeom vdt SIO LCIO mygeant4 ]);
    nativeBuildInputs = hep.wrappers pkgs;

    cmakeFlags = [
        "-DEVTGEN_PYTHIA=ON"
    ];
}