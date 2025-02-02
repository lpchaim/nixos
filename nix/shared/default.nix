{inputs, ...}: let
  inherit (inputs) self;
  inherit (self.lib.config.nix) settings;
  inherit (self.lib.loaders) listNonDefault;
in {
  imports = listNonDefault ./.;

  nix = {
    inherit settings;
  };
  nixpkgs.overlays = builtins.attrValues self.overlays;
}
