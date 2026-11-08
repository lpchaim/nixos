{
  inputs,
  lib,
  self,
  withSystem,
  ...
} @ args: {
  flake.overlays = {
    default = self.overlays.packages;
    lix = import ./lix.nix args;
    nixpkgsVersions = import ./nixpkgsVersions.nix args;
    nuInterpreterStdin = import ./nuInterpreterStdin.nix args;
    packages = import ./packages.nix args;
    python = import ./python.nix args;
    termshot = import ./termshot.nix args;
    vimPlugins = import ./vimPlugins.nix args;
    external = lib.composeManyExtensions [
      inputs.agenix-rekey.overlays.default
      inputs.nix-gaming.overlays.default
      (final: prev:
        withSystem prev.stdenv.hostPlatform.system ({inputs', ...}: {
          panix = inputs'.panix.packages.default;
        }))
    ];
  };
}
