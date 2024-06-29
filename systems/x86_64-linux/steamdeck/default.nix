{ config, inputs, lib, ... }:

let
  inherit (lib.lpchaim.nixos) getTraitModules;
  inherit (lib) mkIf mkForce;
in
{
  imports =
    [
      ./disko.nix
      ./hardware-configuration.nix
      inputs.jovian.nixosModules.default
    ]
    ++ (getTraitModules [
      "composite/base"
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
      steamos.useSteamOSConfig = true;
      decky-loader.enable = true;
      devices.steamdeck = {
        enable = true;
        autoUpdate = true;
        enableGyroDsuService = true;
      };
    };

    networking.networkmanager.enable = true;
    services = mkIf config.jovian.steam.autoStart {
      displayManager.sddm.enable = mkForce false;
      xserver.displayManager.gdm.enable = mkForce false;
    };
  };
}
