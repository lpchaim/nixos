{ lib, ... }:

with lib.lpchaim.home;
{
  imports = getTraitModules [
    "non-nixos"
    "work"
  ];

  config.home = rec {
    stateVersion = "23.05";
    username = "cheina";
    homeDirectory = "/home/${username}";
  };
}
