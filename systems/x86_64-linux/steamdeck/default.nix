{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkForce;
  inherit (lib.lpchaim.nixos) getTraitModules;
  inherit (lib.lpchaim.shared) defaults;
  inherit (lib.lpchaim.storage.btrfs) mkStorage;
in {
  imports =
    [
      inputs.jovian.nixosModules.default
      ./hardware-configuration.nix
      (mkStorage {
        device = "/dev/disk/by-id/nvme-KINGSTON_OM3PDP3512B-A01_50026B7685D47463";
        swapSize = "17G";
      })
    ]
    ++ (getTraitModules [
      "users"
      "wayland"
      "pipewire"
      "de/gnome"
      "gaming"
    ]);

  config = {
    system.stateVersion = "24.05";
    my.gaming.steam.enable = true;
    my.security.u2f.relaxed = true;

    jovian = {
      steam = {
        inherit (defaults.name) user;
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
  };
}
