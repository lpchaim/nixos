{
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs.self.lib.config) name;
in {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    {
      home-manager.users.${name.user} = {
        home.stateVersion = "24.05";
      };
    }
  ];

  my.profiles.graphical = false;
  my.security.u2f.relaxed = true;

  hardware.graphics.enable = false;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  system.stateVersion = "24.05";
  nixpkgs.hostPlatform = "aarch64-linux";
}
