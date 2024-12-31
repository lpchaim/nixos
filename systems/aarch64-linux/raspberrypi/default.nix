{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  my.traits = {
    composite.base.enable = true;
  };
  my.security.u2f.relaxed = true;

  hardware.graphics.enable = false;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  system.stateVersion = "24.05";
}
