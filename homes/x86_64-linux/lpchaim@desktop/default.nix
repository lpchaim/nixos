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
    "llm/high"
  ];

  config.home = rec {
    stateVersion = "24.11";
    username = "lpchaim";
    homeDirectory = "/home/${username}";
  };
}
