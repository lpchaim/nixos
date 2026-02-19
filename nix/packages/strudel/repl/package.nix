{
  fetchFromCodeberg,
  fetchPnpmDeps,
  pnpm,
  pnpmConfigHook,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "strudel-repl";
  version = "1.2.4";

  src = fetchFromCodeberg {
    owner = "uzu";
    repo = "strudel";
    rev = "@strudel/core@${finalAttrs.version}";
    hash = "sha256-lJUM4CjfiaaejIwJCH/udKfk52MoSMhhw8y8l9zgiFg=";
  };

  nativeBuildInputs = [
    pnpm
    pnpmConfigHook
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
