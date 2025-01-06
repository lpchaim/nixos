{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (inputs.self.lib.config) name;
  cfg = config.my.modules.steamos;
in {
  imports = [
    inputs.jovian.nixosModules.default
  ];

  options.my.modules.steamos.enable = lib.mkEnableOption "SteamOS";

  config = lib.mkIf (cfg.enable) {
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

    services = lib.mkIf config.jovian.steam.autoStart {
      displayManager.sddm.enable = lib.mkForce false;
      xserver.displayManager.gdm.enable = lib.mkForce false;
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
