{ lib, ... }:

let
  inherit (lib.lpchaim.home) getTraitModules;
in
{
  imports = getTraitModules [
    "de/gnome"
    "de/hyprland"
    "apps/gui"
    "apps/media"
  ];

  config.home = rec {
    stateVersion = "24.05";
    username = "lpchaim";
    homeDirectory = "/home/${username}";
  };
}
