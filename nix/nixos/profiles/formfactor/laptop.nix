# Laptop-specific configurations
{
  config,
  lib,
  ...
}: let
  cfg = config.my.profiles.formfactor.laptop;
in {
  options.my.profiles.formfactor.laptop = lib.mkEnableOption "laptop profile";
  config = lib.mkIf cfg {
    hardware.sensor.iio.enable = true;

    powerManagement.enable = true;

    programs.iio-hyprland.enable = config.programs.hyprland.enable;

    services = {
      auto-cpufreq = {
        enable = !config.services.power-profiles-daemon.enable;
        settings = {
          battery = {
            turbo = "never";
          };
          charger = {
            turbo = "auto";
          };
        };
      };
      fprintd.enable = true;
      thermald.enable = true;
    };
  };
}
