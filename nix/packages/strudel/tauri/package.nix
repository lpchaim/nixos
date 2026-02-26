{
  lib,
  cargo-tauri_1,
  fetchFromCodeberg,
  fetchPnpmDeps,
  glib-networking,
  libsoup_2_4,
  nodejs,
  openssl,
  pkg-config,
  pnpm,
  pnpmConfigHook,
  rustPlatform,
  stdenv,
  webkitgtk_4_0,
  wrapGAppsHook4,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "strudel-tauri";
  version = "1.2.4";

  cargoHash = "sha256-QGw8eufJT+ft6PFyDMEKpoINDuGGapawnJzRl83uptc=";
  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  src = fetchFromCodeberg {
    owner = "uzu";
    repo = "strudel";
    rev = "@strudel/core@${finalAttrs.version}";
    hash = "sha256-lJUM4CjfiaaejIwJCH/udKfk52MoSMhhw8y8l9zgiFg=";
  };
  cargoPatches = [
    ./001-dependencies.patch # Removes tauri-plugin-clipboard-manager until I can figure out how to include it properly
  ];

  nativeBuildInputs =
    [
      cargo-tauri_1.hook
      nodejs
      pkg-config
      pnpm
      pnpmConfigHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [wrapGAppsHook4];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    libsoup_2_4
    openssl
    webkitgtk_4_0
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-tP0N83fph/5LLBXGZsNpKGqrubGDucscQXmBNnLZG/A=";
  };

  meta = {
    description = "Web-based environment for live coding algorithmic pattern";
    homepage = "https://codeberg.org/uzu/strudel";
    changelog = "https://codeberg.org/uzu/strudel/releases/tag/@strudel/core@${finalAttrs.version}";
    # platforms = lib.platforms.unix;
    # mainProgram = "strudel";
  };
})
