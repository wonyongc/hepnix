let
  hep = import ./hepcore.nix;
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {

    pname = "hepmc3";
    version = "3.2.3";

    src = pkgs.fetchgit {
      url = "https://gitlab.cern.ch/hepmc/HepMC3";
      rev = "d5d54879f1c498e02e5f2dcf2e3d841fe4f7421a";
      sha256 = "sha256-IxGcw5Y+Ls7VV06PyPrT2SEToV1uoAIvJDZyyEb4qUk=";
    };

    buildInputs = hep.core pkgs ++ (with pkgs; [ AIDA podio edm4hep VecCore VecGeom vdt SIO LCIO hepPDT ]);
    nativeBuildInputs = hep.wrappers pkgs;

    cmakeFlags = [
        "-DCMAKE_CXX_STANDARD=17"
        "-DHEPMC3_ENABLE_PYTHON=ON"
        "-DHEPMC3_PYTHON_VERSIONS=3.X"
        "-DHEPMC3_Python_SITEARCH310=${placeholder "out"}/${pkgs.python310Full.sitePackages}"
    ];

    installCheckPhase = ''
    PYTHONPATH=${placeholder "out"}/${pkgs.python310Full.sitePackages} python -c 'import pyHepMC3'
  '';
}
