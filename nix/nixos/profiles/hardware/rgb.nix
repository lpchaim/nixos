{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.self.lib.services) mkOneShotSleepService;
  inherit (config.services.hardware.openrgb) package;
  cfg = config.my.profiles.hardware.rgb;
in {
  options.my.profiles.hardware.rgb = lib.mkEnableOption "RGB profile";
  config = lib.mkIf cfg {
    environment.systemPackages = [package];
    services.hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };
    services.udev.packages = [package];

    systemd.services.rgb-off = mkOneShotSleepService {
      serviceConfig = let
        command = "${package}/bin/openrgb --color 000000";
      in {
        ExecStart = command;
        ExecStop = command;
      };
    };
  };
}
