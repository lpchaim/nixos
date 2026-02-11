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

  my = {
    ci.build = true;
    security.u2f.relaxed = true;
    profiles.graphical = false;
  };

  hardware.graphics.enable = false;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  nixpkgs.hostPlatform = "aarch64-linux";

  system.stateVersion = "24.05";
  home-manager.users.${name.user}.home.stateVersion = "24.05";
}
