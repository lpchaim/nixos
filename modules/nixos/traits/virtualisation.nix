{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    distrobox
  ];
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      enableNvidia = true;
    };
  };
  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };
}
