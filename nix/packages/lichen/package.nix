{
  lib,
  stdenv,
  fetchFromSourcehut,
  gcc,
  hare,
  hareHook,
  lua,
  makeWrapper,
  qbe,
}:
stdenv.mkDerivation (finalAttrs: rec {
  pname = "lichen";
  version = "0.22.0-unstable";

  src = fetchFromSourcehut {
    owner = "~mikaela-md";
    repo = "lcc";
    rev = "04858821e088297c328ee07679b6babbb4b28d68";
    hash = "sha256-Jj+ki1xT+JgsGN1gjobBEfU+Xgeddnbm53Fhyj04f9A=";
  };

  nativeBuildInputs = [
    hareHook
    makeWrapper
  ];

  buildInputs = [
    hare
    qbe
  ];

  nativeInstallCheckInputs = [
    lua
  ];

  patches = [
    ./001-tests.patch
  ];

  buildPhase = ''
    runHook preBuild

    pushd ./src
    mkdir -p $out/bin
    hare build -o $out/bin/lcc
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    wrapProgram $out/bin/lcc \
      --prefix PATH ":" ${lib.makeBinPath [gcc qbe]} \
      --add-flags "-std $out/lib"

    mkdir -p $out/lib
    cp -r ${src}/lib/. $out/lib/
    rm $out/lib/README.md

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preCheck

    set -e
    pushd ./scripts
    export PATH="$PATH:$out/bin"
    ${lib.getExe lua} ./run_tests.lua
    popd

    runHook postCheck
  '';

  meta = {
    description = "Lichen compiler";
    homepage = "https://git.sr.ht/~mikaela-md/lcc";
    changelog = "https://git.sr.ht/~mikaela-md/lcc/commit/${src.rev}";
    platforms = lib.platforms.unix;
    mainProgram = "lcc";
  };

  passthru.my.ci.buildFor = ["x86_64-linux"];
})
