{
  pkgs,
  self,
  ...
}: let
  inherit (self.vars) name;
in {
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
  ];

  my = {
    ci.build = true;
    networking.trusted = true;
    security.u2f.relaxed = true;
    profiles = {
      headless = true;
      server = true;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  system.stateVersion = "24.05";
  home-manager.users.${name.user}.home.stateVersion = "24.05";
}
