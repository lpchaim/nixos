# Laptop configurations

{ config, lib, pkgs, ... }:

{
  hardware.sensor.iio.enable = true;

  powerManagement.enable = true;

  services = {
    auto-cpufreq = {
      enable = true;
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
    fwupd.enable = true;
    thermald.enable = true;
  };
}
