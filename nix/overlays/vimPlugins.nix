{self, ...}: final: prev: let
  inherit (prev.stdenv.hostPlatform) system;
in {
  vimPlugins =
    prev.vimPlugins
    // self.legacyPackages.${system}.vimPlugins or {};
}
