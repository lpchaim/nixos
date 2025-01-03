{inputs, ...}: let
  inherit (inputs) self;
  inherit (inputs.self.lib) shared;
in {
  imports = [
    ./theming
  ];

  nix = {
    inherit (shared.nix) settings;
  };
  nixpkgs.overlays = import "${self}/nix/overlays" {inherit inputs;};
}
