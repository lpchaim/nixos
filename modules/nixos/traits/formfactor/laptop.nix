# Laptop-specific configurations

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
    power-profiles-daemon.enable = false; # Conflicts with auto-cpufreq
    fprintd.enable = true;
    thermald.enable = true;
  };
}
