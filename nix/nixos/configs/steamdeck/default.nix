{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkForce;
  inherit (inputs.self.lib.config) name;
in {
  imports = [
    inputs.jovian.nixosModules.default
    ./hardware-configuration.nix
    ./storage.nix
  ];

  my.profiles = {
    kernel = false;
    de.gnome = true;
  };
  my.gaming.enable = false;
  my.gaming.steam.enable = true;
  my.security.u2f.relaxed = true;

  jovian = {
    steam = {
      inherit (name) user;
      enable = true;
      autoStart = true;
      desktopSession = "gnome";
    };
    steamos = {
      enableMesaPatches = true;
      useSteamOSConfig = true;
    };
    decky-loader.enable = true;
    devices.steamdeck = {
      enable = true;
      autoUpdate = true;
      enableGyroDsuService = true;
    };
  };

  services = mkIf config.jovian.steam.autoStart {
    displayManager.sddm.enable = mkForce false;
    xserver.displayManager.gdm.enable = mkForce false;
  };
  time = {
    hardwareClockInLocalTime = mkForce false;
    timeZone = mkForce null;
  };

  system.stateVersion = "24.05";

  home-manager.users.${name.user} = {
    dconf.settings."org/gnome/shell".favorite-apps = ["steam.desktop"];
    home.stateVersion = "24.05";
  };
}
