{ config, pkgs, ... }:

let package = config.services.hardware.openrgb.package;
in {
  environment.systemPackages = [ package ];
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
  };
  services.udev.packages = [ package ];
  powerManagement = {
    powerDownCommands = ''
      ${package}/bin/openrgb --color 000000
    '';
    powerUpCommands = ''
      ${package}/bin/openrgb --color 000000
    '';
  };
}
