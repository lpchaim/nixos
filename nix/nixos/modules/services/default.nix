{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
  getFileSystemsByFsType = fsType:
    lib.filterAttrs (_: fs: fs.fsType == fsType) config.fileSystems;
in {
  # Services
  services = {
    blueman.enable = true;
    btrfs.autoScrub = let
      btrfsFileSystems = getFileSystemsByFsType "btrfs";
    in
      lib.mkIf (btrfsFileSystems != {}) {
        enable = true;
        interval = "monthly";
        fileSystems =
          if btrfsFileSystems ? "/"
          then ["/"]
          else lib.attrNames btrfsFileSystems;
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
      enable = mkDefault false;
      openFirewall = true;
      host = "127.0.0.1";
      port = 11434;
    };
    openssh = {
      enable = true;
      allowSFTP = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = mkDefault false;
        PermitRootLogin = mkDefault "no";
      };
    };
    power-profiles-daemon.enable = true;
    printing.enable = true;
    udisks2.enable = true;
  };
  services.xserver.enable = lib.mkDefault true;
}
