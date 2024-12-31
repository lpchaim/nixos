# Laptop-specific configurations
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.traits.formfactor.laptop;
in {
  options.my.traits.formfactor.laptop.enable = lib.mkEnableOption "laptop trait";
  config = lib.mkIf cfg.enable {
    my.traits = {
      pipewire.enable = true;
      wayland.enable = true;
    };

    hardware.graphics.enable = true;
    hardware.sensor.iio.enable = true;

    environment.systemPackages = with pkgs; [
      nix-software-center
    ];

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
