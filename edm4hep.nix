let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "edm4hep";
    version = "v00-03";

    src = pkgs.fetchgit {
      url = "https://github.com/key4hep/EDM4hep";
      rev = "e17d47ab9f17f3a56fb90550d307275cacd93153";
      sha256 = "sha256-0yB2zO49i7zgx9nht3JH7u/URBQ0ei1MP4fbtNJ1LyI=";
    };

    buildInputs = hep.core pkgs ++ (with pkgs; [ podio SIO ]);
    nativeBuildInputs = hep.wrappers pkgs;
}