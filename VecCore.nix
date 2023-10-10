let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "VecCore";
    version = "0.6.0";

    src = pkgs.fetchgit {
      url = "https://gitlab.cern.ch/VecGeom/VecCore";
      rev = "5f5ff6942e3acb0dd5e278d928fab2ced5bb6a86";
      sha256 = "sha256-TqB2s74YXRyBotpCrwPnC9R4Q2BHFH68sF7MczMydqk=";
    };

    buildInputs = hep.core pkgs;
    nativeBuildInputs = hep.wrappers pkgs;
}