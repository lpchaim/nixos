{lib, ...}: let
  inherit (lib.lpchaim.home) getTraitModules;
in {
  imports = getTraitModules [
    "non-nixos"
  ];

  config.home = rec {
    stateVersion = "23.11";
    username = "lupec";
    homeDirectory = "/home/${username}";
  };
}
