{
  inputs,
  lib,
  ...
}: let
  inherit (inputs) self;
in {
  imports = [
    ./flatpak.nix
    ./nix.nix
    ./secrets.nix
    ./theming.nix
  ];

  options = {
    my.config = lib.mkOption {default = self.lib.config;};
  };
}
