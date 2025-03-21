# SPDX-FileCopyrightText: 2024 Tom Hubrecht <tom.hubrecht@dgnum.eu>
#
# SPDX-License-Identifier: EUPL-1.2

{
  lib,
  stdenv,
  fetchFromGitLab,
  gmp,
  mpfr,
  boost,

  autoconf,
  automake,
  bison,
  flex,

}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gappa";
  version = "1.6.0";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "gappa";
    repo = "gappa";
    rev = "gappa-${finalAttrs.version}";
    hash = "sha256-vwXEDSoclnVflC5cBZXNUjw8cFsWaDBA1e3F9AHHqwc=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    bison
    flex
  ];

  buildInputs = [
    gmp
    mpfr
    boost.dev
  ];

  configurePhase = ''
    ./autogen.sh
    ./configure --prefix="$out"
  '';

  buildPhase = ''
    ./remake
  '';

  installPhase = ''
    ./remake install
  '';

  doCheck = true;

  checkPhase = ''
    ./remake check
  '';

  meta = {
    description = "Gappa is a tool intended to help verifying and formally proving properties on numerical programs dealing with floating-point or fixed-point arithmetic";
    homepage = "https://gitlab.inria.fr/gappa/gappa";
    license = with lib.licenses; [
      gpl3Only
      cecill21
    ];
    maintainers = [ ];
    mainProgram = "gappa";
    platforms = lib.platforms.all;
  };
})
