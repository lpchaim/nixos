{
  inputs,
  lib,
  ...
}: let
  inherit (inputs) self;
  inherit (self.lib.config.nix) settings;
in {
  imports = [
    ./theming.nix
  ];

  options = {
    my.config = lib.mkOption {default = self.lib.config;};
  };

  config = {
    nix = {inherit settings;};
  };
}
