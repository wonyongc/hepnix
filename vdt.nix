let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "vdt";
    version = "0.4.3";

    src = pkgs.fetchgit {
      url = "https://github.com/dpiparo/vdt";
      rev = "c57ca420d0d642b577313885bbaaedf4d63e01d5";
      sha256 = "sha256-gVbBHqO9qvViIvf5vTk+DZvCV2TF+8Ls6hbiGbJDjGs=";
    };

    buildInputs = hep.core pkgs;
    nativeBuildInputs = hep.wrappers pkgs;
}