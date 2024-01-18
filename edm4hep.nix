let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "edm4hep";
    version = "v00-04-01";

    src = pkgs.fetchgit {
      url = "https://github.com/key4hep/EDM4hep";
      rev = "18a8ffe30569ee66a5d74c5af2ffaa11d55886d3";
      sha256 = "sha256-ZEGt7epqN7OjjWWlrxukKJah2oxucIVvtAAgcSxwePg=";
    };

    buildInputs = hep.core pkgs ++ (with pkgs; [ podio SIO ]);
    nativeBuildInputs = hep.wrappers pkgs;
}