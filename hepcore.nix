{
  core = ps: with ps; [
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

  wrappers = ps: with ps; [
    qt5.wrapQtAppsHook
  ];

}