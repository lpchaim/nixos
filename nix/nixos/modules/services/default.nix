{
  config,
  lib,
  ...
}: let
  cfg = config.my.services;
  getFileSystemsByFsType = fsType:
    lib.filterAttrs (_: fs: fs.fsType == fsType) config.fileSystems;
in {
  imports = [
    ./home-assistant
    ./swayosd.nix
  ];

  options.my.services.enable = lib.mkEnableOption "custom services";

  config = lib.mkIf cfg.enable {
    services = {
      acpid.enable = true;
      blueman.enable = true;
      btrfs.autoScrub = let
        btrfsFileSystems = getFileSystemsByFsType "btrfs";
      in
        lib.mkIf (btrfsFileSystems != {}) {
          enable = true;
          interval = "monthly";
          fileSystems = lib.attrNames btrfsFileSystems;
        };
      devmon.enable = true;
      fstrim = {
        enable = true;
        interval = "weekly";
      };
      fwupd.enable = true;
      gvfs.enable = true;
      libinput.enable = true;
      ollama = {
        enable = lib.mkDefault false;
        openFirewall = true;
        host = "127.0.0.1";
        port = 11434;
      };
      power-profiles-daemon.enable = true;
      printing.enable = true;
      udisks2.enable = true;
      upower.enable = true;
    };
  };
}
