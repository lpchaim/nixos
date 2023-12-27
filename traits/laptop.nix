# Laptop configurations

{ config, lib, pkgs, ... }:

{
  hardware.sensor.iio.enable = true;

  services = {
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          turbo = "never";
        };
      };
    };
    thermald.enable = true;
  };
}
