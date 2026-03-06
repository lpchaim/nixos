{
  fileSystems = let
    boot.device = "/dev/disk/by-uuid/12CE-A600";
    root.device = "/dev/disk/by-uuid/322a6d8e-f946-4d60-98a3-dd1af1373c79";
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
      options = ["subvol=@home"] ++ options;
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
