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
    my.profiles = {
      pipewire = true;
      wayland = true;
    };

    hardware.graphics.enable = true;
    hardware.sensor.iio.enable = true;

    powerManagement.enable = true;

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
