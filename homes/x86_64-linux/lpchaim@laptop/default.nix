{ lib, ... }:

with lib.lpchaim.home;
{
  imports = getTraitModules [
    "de/gnome"
    "de/hyprland"
    "apps/gui"
    "apps/media"
  ];

  config.home = rec {
    stateVersion = "23.05";
    username = "lpchaim";
    homeDirectory = "/home/${username}";
  };
}
