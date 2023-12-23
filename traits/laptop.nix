# Laptop configurations

{ config, lib, pkgs, ... }:

{
  hardware.sensor.iio.enable = true;
  services.thermald.enable = true;
  # services.tlp.enable = true;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        turbo = "never";
      };
    };
  };
}
