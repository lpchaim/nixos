{ lib, ... }:

with lib.lpchaim.nixos;
{
  imports =
    [
      ./disko.nix
      ./hardware-configuration.nix
    ]
    ++ (getTraitModules [
      "composite/base"
      "formfactor/laptop"
      "de/gnome"
      "de/hyprland"
    ]);

  networking.hostName = "laptop";
  system.stateVersion = "23.11";
}
