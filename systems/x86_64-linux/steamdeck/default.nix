{ config
, lib
, ...
}:

let
  inherit (lib) mkIf mkForce;
  inherit (lib.lpchaim.nixos) getTraitModules;
in
{
  imports =
    [
      ./disko.nix
      ./hardware-configuration.nix
    ]
    ++ (getTraitModules [
      "users"
      "wayland"
      "pipewire"
      "de/gnome"
      "gaming"
    ]);

  config = {
    networking.hostName = "steamdeck";
    system.stateVersion = "24.05";

    jovian = {
      steam = {
        enable = true;
        autoStart = true;
        desktopSession = "gnome";
      };
      steamos = {
        enableMesaPatches = false;
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
  };
}
