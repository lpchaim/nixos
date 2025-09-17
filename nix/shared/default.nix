{inputs, ...}: let
  inherit (inputs) self;
  inherit (self.lib.config.nix) settings;
in {
  imports = [
    ./theming.nix
  ];

  nix = {inherit settings;};
}
