{
  inputs,
  ezModules,
  ...
}: let
  inherit (inputs.self.lib.config) name;
in {
  imports = [
    ezModules.steamos
    ./hardware-configuration.nix
    ./storage.nix
  ];

  my.profiles = {
    de.gnome = true;
    kernel = false;
  };
  my.gaming.enable = false;
  my.gaming.steam.enable = true;
  my.modules.steamos.enable = true;
  my.security.u2f.relaxed = true;

  boot.loader = {
    grub.configurationLimit = 2;
    systemd-boot.configurationLimit = 2;
  };
  systemd.services.systemd-suspend.environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";

  system.stateVersion = "24.05";
  home-manager.users.${name.user}.home.stateVersion = "24.05";
}
