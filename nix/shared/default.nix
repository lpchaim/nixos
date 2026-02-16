{inputs, ...}: let
  inherit (inputs) self;
  inherit (self.lib.config.nix) settings;
in {
  imports = [
    ./secrets.nix
    ./theming.nix
  ];

  nix = {inherit settings;};
}
