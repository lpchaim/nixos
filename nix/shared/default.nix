{inputs, ...}: let
  inherit (inputs) self;
  inherit (inputs.self.lib) shared;
  inherit (inputs.self.lib.loaders) listNonDefault;
in {
  imports = listNonDefault ./.;

  nix = {
    inherit (shared.nix) settings;
  };
  nixpkgs.overlays = import "${self}/nix/overlays" {inherit inputs;};
}
