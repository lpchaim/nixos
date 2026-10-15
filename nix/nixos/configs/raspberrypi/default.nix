{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
  ];

  my = {
    ci.build = true;
    hardware.ups.enable = true;
    networking.trusted = true;
    security.u2f.relaxed = true;
    services.home-assistant.enable = true;
    profiles = {
      headless = true;
      server = true;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  system.stateVersion = "24.05";
}
