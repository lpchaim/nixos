{self, ...} @ args: {
  flake.overlays = {
    default = self.overlays.packages;
    external = import ./external.nix args;
    lix = import ./lix.nix args;
    nixpkgsVersions = import ./nixpkgsVersions.nix args;
    nuInterpreterStdin = import ./nuInterpreterStdin.nix args;
    packages = import ./packages.nix args;
    python = import ./python.nix args;
    termshot = import ./termshot.nix args;
    vimPlugins = import ./vimPlugins.nix args;
  };
}
