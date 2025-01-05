{inputs, ...}: let
  inherit (inputs.self.lib.config) name;
  inherit (inputs.self.lib.storage.btrfs) mkStorage;
  inherit (inputs.self.lib.storage.ntfs) mkSecondaryStorage;
in {
  imports = [
    ./hardware-configuration.nix
    (mkStorage {
      device = "/dev/disk/by-id/nvme-Corsair_MP600_PRO_XT_214279380001310131BD";
      swapSize = "35G";
    })
    (mkSecondaryStorage {
      device = "/dev/disk/by-id/ata-ADATA_SU630_2J0220042661-part1";
      mountPoint = "/run/media/${name.user}/storage";
    })
    {
      home-manager.users.${name.user} = {
        home.stateVersion = "24.11";
      };
    }
  ];

  my.profiles = {
    formfactor.desktop = true;
    de.gnome = true;
    de.hyprland = true;
    hardware.gpu.nvidia = true;
    hardware.rgb = true;
  };
  my.gaming.enable = true;
  my.networking.tailscale.trusted = true;
  my.security.secureboot.enable = true;

  system.stateVersion = "23.11";
}
