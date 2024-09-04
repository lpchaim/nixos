{lib, ...}: let
  inherit (lib.lpchaim.home) getTraitModules;
in {
  imports = getTraitModules [
    "de/gnome"
    "de/hyprland"
    "apps/gui"
    "apps/media"
  ];

  config.home.stateVersion = "24.05";
}
