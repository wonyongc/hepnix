let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "VecGeom";
    version = "1.1.8";

    src = pkgs.fetchgit {
      url = "https://gitlab.cern.ch/VecGeom/VecGeom";
      rev = "5a275d77ef80b12240d59fd276231ad50d5df577";
      sha256 = "sha256-/RYv8U9OlJ7BuDsFAKB/UkEelkUCGGLSfZKIF6KXrM8=";
    };

    buildInputs = hep.core pkgs;
    nativeBuildInputs = hep.wrappers pkgs;
}