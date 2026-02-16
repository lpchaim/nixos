{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (config.my.config) name;
  cfg = config.my.steamos;
in {
  options.my.steamos.enable = lib.mkEnableOption "SteamOS";

  config = lib.mkIf (cfg.enable) {
    jovian = {
      steam = {
        inherit (name) user;
        enable = true;
        autoStart = true;
        desktopSession = "gnome";
      };
      steamos.useSteamOSConfig = true;
      decky-loader.enable = true;
      devices.steamdeck = {
        enable = true;
        autoUpdate = true;
        enableGyroDsuService = true;
        enableVendorDrivers = true;
      };
    };

    services = lib.mkIf config.jovian.steam.autoStart {
      displayManager.sddm.enable = lib.mkForce false;
      displayManager.gdm.enable = lib.mkForce false;
    };
    time = {
      hardwareClockInLocalTime = lib.mkForce false;
      timeZone = lib.mkForce null;
    };

    home-manager.users.${name.user} = {
      dconf.settings."org/gnome/shell".favorite-apps = ["steam.desktop"];
    };
  };
}
