let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "LCIO";
    version = "v02-16-01";

    src = pkgs.fetchgit {
      url = "https://github.com/iLCSoft/LCIO";
      rev = "8f9e86b93b7d5d83221fabb872ed7e82f1638476";
      sha256 = "sha256-slKsmb5KuQDRYGLJ+ON31aC6SBy6cMO+3jt1e6vviUk=";
    };

    buildInputs = hep.core pkgs ++ (with pkgs; [ podio edm4hep ]);
    nativeBuildInputs = hep.wrappers pkgs;
}