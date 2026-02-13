{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.de.hyprland.hypridle;
in {
  options.my.de.hyprland.hypridle = {
    enable =
      lib.mkEnableOption "Hypridle"
      // {default = config.my.de.hyprland.enable;};
    lockCmd = lib.mkOption {
      description = "Command to lock the screen";
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.hypridle.settings.general.lock_cmd != null;
        message = "config.services.hypridle.settings.general.lock_cmd must be set for hypridle to work properly";
      }
    ];

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = cfg.lockCmd;
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = "60";
            on-timeout = "${lib.getExe pkgs.brightnessctl} -s set 50%-";
            on-resume = "${lib.getExe pkgs.brightnessctl} -r";
          }
          {
            timeout = "120";
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = "180";
            on-timeout = "loginctl lock-session";
          }
        ];
      };
    };
  };
}
