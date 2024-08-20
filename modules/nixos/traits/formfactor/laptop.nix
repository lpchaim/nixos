# Laptop-specific configurations
{ config, lib, ... }:

{
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
}
