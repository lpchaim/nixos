{
  config,
  inputs,
  ezModules,
  ...
}: let
  inherit (config.my.config) name;
in {
  imports = [
    inputs.jovian.nixosModules.default
    ezModules.steamos
    ./hardware-configuration.nix
    ./storage.nix
  ];

  my = {
    steamos.enable = true;
    gaming.enable = false;
    gaming.steam.enable = true;
    security.u2f.relaxed = true;
    kernel.enable = false;
    profiles = {
      de.gnome = true;
      graphical = true;
    };
  };

  boot.loader = {
    grub.configurationLimit = 2;
    systemd-boot.configurationLimit = 2;
  };
  systemd.services.systemd-suspend.environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";

  system.stateVersion = "24.05";
  home-manager.users.${name.user}.home.stateVersion = "24.05";
}
