{
  description = "hep packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/22.11";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, ... }@inputs:

    inputs.utils.lib.eachSystem [ "x86_64-linux" "aarch64-darwin" ]

    (system: let

      pkgs = import nixpkgs {
        inherit system;
        overlays = [];
        config.allowUnfree = true;
      };

      lib = pkgs.lib;

    in {
      heppkgs = lib.recurseIntoAttrs {
        AIDA = pkgs.callPackage ./AIDA.nix {};
        SIO = pkgs.callPackage ./SIO.nix {};
        VecCore = pkgs.callPackage ./VecCore.nix {};
        VecGeom = pkgs.callPackage ./VecGeom.nix {};
        vdt = pkgs.callPackage ./vdt.nix {};
        podio = pkgs.callPackage ./podio.nix {};
        edm4hep = pkgs.callPackage ./edm4hep.nix {};
        LCIO = pkgs.callPackage ./LCIO.nix {};
        geant4 = pkgs.callPackage ./geant4.nix {};
        dd4hep = pkgs.callPackage ./dd4hep.nix {};
        evtgen = pkgs.callPackage ./evtgen.nix {};
        gaudi = pkgs.callPackage ./gaudi.nix {};
        k4FWCore = pkgs.callPackage ./k4FWCore.nix {};
        k4SimGeant4 = pkgs.callPackage ./k4SimGeant4.nix {};
        k4Gen = pkgs.callPackage ./k4Gen.nix {};
        SimSiPM = pkgs.callPackage ./SimSiPM.nix {};

      };

      hepcore = import ./hepcore.nix;
    }
    );


}

#
#buildInputs = subproject.devShells.${system}.default.buildInputs ++ (with pkgs.buildPackages; [
#
#]);#parent flake libs