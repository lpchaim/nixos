# Laptop-specific configurations
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../pipewire.nix
    ../wayland.nix
  ];

  config = {
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
