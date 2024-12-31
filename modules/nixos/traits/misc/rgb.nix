{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.services.hardware.openrgb) package;
  cfg = config.my.traits.misc.rgb;
in {
  options.my.traits.misc.rgb.enable = lib.mkEnableOption "RGB trait";
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [package];
    services.hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };
    services.udev.packages = [package];
    powerManagement = {
      powerDownCommands = ''
        ${package}/bin/openrgb --color 000000
      '';
      powerUpCommands = ''
        ${package}/bin/openrgb --color 000000
      '';
    };
  };
}
