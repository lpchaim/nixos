{
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs) self;
  inherit (inputs.self.lib) shared;
in {
  imports = [
    ./theming
  ];

  nix = {
    inherit (shared.nix) settings;
    package = pkgs.lix;
  };
  nixpkgs.overlays = import "${self}/nix/overlays" {inherit inputs;};
}
