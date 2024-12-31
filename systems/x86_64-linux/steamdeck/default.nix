{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkForce;
  inherit (lib.lpchaim.shared) defaults;
  inherit (lib.lpchaim.storage.btrfs) mkStorage;
in {
  imports = [
    inputs.jovian.nixosModules.default
    ./hardware-configuration.nix
    (mkStorage {
      device = "/dev/disk/by-id/nvme-KINGSTON_OM3PDP3512B-A01_50026B7685D47463";
      swapSize = "17G";
    })
  ];

  my.traits = {
    users.enable = true;
    wayland.enable = true;
    pipewire.enable = true;
    de.gnome.enable = true;
  };
  my.gaming.enable = false;
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
  time = {
    hardwareClockInLocalTime = mkForce false;
    timeZone = mkForce null;
  };

  fileSystems."/run/media/${defaults.name.user}/sdcard" = {
    device = "/dev/disk/by-id/mmc-EF8S5_0x3b3163d0-part1";
    options = [
      "defaults"
      "subvol=@"
      "compress=zstd"
      "noatime"
      "nofail"
    ];
  };

  system.stateVersion = "24.05";
}
