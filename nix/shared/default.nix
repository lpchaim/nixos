{inputs, ...}: let
  inherit (inputs) self;
  inherit (inputs.self.lib.config.nix) settings;
  inherit (inputs.self.lib.loaders) listNonDefault;
in {
  imports = listNonDefault ./.;

  nix = {
    inherit settings;
  };
  nixpkgs.overlays = import "${self}/nix/overlays" {inherit inputs;};
}
