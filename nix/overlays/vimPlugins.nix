{inputs, ...}: final: prev: let
  inherit (prev.stdenv.hostPlatform) system;
in {
  vimPlugins =
    prev.vimPlugins
    // inputs.self.legacyPackages.${system}.vimPlugins or {};
}
