{
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs.self.lib.config) name;
in {
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
  ];

  my.profiles.graphical = false;
  my.security.u2f.relaxed = true;

  hardware.graphics.enable = false;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  nixpkgs.hostPlatform = "aarch64-linux";

  system.stateVersion = "24.05";
  home-manager.users.${name.user}.home.stateVersion = "24.05";
}
