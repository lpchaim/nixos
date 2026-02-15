{inputs, ...}: let
  inherit (inputs) self;
  inherit (self.lib.config.nix) settings;
in {
  imports = [
    ./agenix-rekey.nix
    ./theming.nix
  ];

  nix = {inherit settings;};
}
