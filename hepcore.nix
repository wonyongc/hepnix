{
  core = pkgs: with pkgs; [
    boost175
    cmake
    coin3d
    curl
    doxygen
    fmt
    fftw
    freetype
    gdb
    gsl
    hdf5
    hwloc
    libsForQt5.soqt
    libGLU
    libGL
    libunwind
    libuuid
    libxml2
    nlohmann_json
    microsoft_gsl
    motif
    openssl
    tbb
    pkg-config
    python310Full
    qt5Full
    sqlite
    xercesc
    vtk
    xz
    xorg.libXext
    xorg.libXmu
    xorg.libX11
    zlib

    catch2_3
    cppunit
    gperftools
    jemalloc
    log4cxx
    range-v3

    clhep
    hepmc3
    fastjet
    lhapdf
    pythia
    root
    vc
  ];

  wrappers = pkgs: with pkgs; [
    qt5.wrapQtAppsHook
  ];

  overlaid = pkgs: with pkgs; [
    podio
    edm4hep
    VecCore
    VecGeom
    vdt
    SIO
    LCIO
    geant4
    dd4hep
    evtgen
    gaudi
    K4FWCore
    k4SimGeant4
    k4Gen
  ];

  overlays = [
    (final: prev: {
      AIDA = prev.callPackage ./AIDA.nix {};
      SIO = prev.callPackage ./SIO.nix {};
      VecCore = prev.callPackage ./VecCore.nix {};
      VecGeom = prev.callPackage ./VecGeom.nix {};
      vdt = prev.callPackage ./vdt.nix {};
      podio = prev.callPackage ./podio.nix {};
      edm4hep = prev.callPackage ./edm4hep.nix {};
      LCIO = prev.callPackage ./LCIO.nix {};
      geant4 = prev.callPackage ./geant4.nix {};
      dd4hep = prev.callPackage ./dd4hep.nix {};
      evtgen = prev.callPackage ./evtgen.nix {};
      gaudi = prev.callPackage ./gaudi.nix {};
      k4FWCore = prev.callPackage ./k4FWCore.nix {};
      k4SimGeant4 = prev.callPackage ./k4SimGeant4.nix {};
      k4Gen = prev.callPackage ./k4Gen.nix {};
      SimSiPM = prev.callPackage ./SimSiPM.nix {};
    })
  ];


}