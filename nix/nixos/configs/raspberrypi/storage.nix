{
  fileSystems = let
    boot.device = "/dev/disk/by-id/usb-Argon_Forty_000000000F12-0:0-part1";
    root.device = "/dev/disk/by-id/usb-Argon_Forty_000000000F12-0:0-part2";
    options = ["compress=zstd" "noatime"];
  in {
    "/boot" = {
      inherit (boot) device;
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
    "/" = {
      inherit (root) device;
      fsType = "btrfs";
      options = ["subvol=@"] ++ options;
    };
    "/home" = {
      inherit (root) device;
      fsType = "btrfs";
      options = ["subvol=@home" "nofail"] ++ options;
    };
    "/nix" = {
      inherit (root) device;
      fsType = "btrfs";
      options = ["subvol=@nix"] ++ options;
    };
    "/var/cache" = {
      inherit (root) device;
      fsType = "btrfs";
      options = ["subvol=@cache" "nofail"] ++ options;
    };
    "/var/log" = {
      inherit (root) device;
      fsType = "btrfs";
      options = ["subvol=@log" "nofail"] ++ options;
    };
  };
}
