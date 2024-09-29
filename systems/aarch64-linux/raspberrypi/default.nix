{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.lpchaim.nixos) getTraitModules;
in {
  imports =
    [
      ./hardware-configuration.nix
      ./disko.nix
    ]
    ++ (getTraitModules [
      "composite/base"
    ]);

  config = {
    system.stateVersion = "24.05";
    hardware.graphics.enable = false;
    boot.kernelPackages = pkgs.linuxPackages_latest;
    my.security.u2f.relaxed = true;
  };
}
