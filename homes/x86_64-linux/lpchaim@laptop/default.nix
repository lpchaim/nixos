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
    "llm/low"
  ];

  config.home = rec {
    stateVersion = "23.05";
    username = "lpchaim";
    homeDirectory = "/home/${username}";
  };
}
