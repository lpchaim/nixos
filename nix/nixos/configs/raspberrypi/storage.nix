{
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/12CE-A600";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/322a6d8e-f946-4d60-98a3-dd1af1373c79";
    fsType = "btrfs";
    options = ["subvol=@" "compress=zstd" "noatime"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/322a6d8e-f946-4d60-98a3-dd1af1373c79";
    fsType = "btrfs";
    options = ["subvol=@home" "compress=zstd" "noatime"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/322a6d8e-f946-4d60-98a3-dd1af1373c79";
    fsType = "btrfs";
    options = ["subvol=@nix" "compress=zstd" "noatime"];
  };
}
