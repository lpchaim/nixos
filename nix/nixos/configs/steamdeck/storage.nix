{self, ...}: {
  disko.devices.disk.main = self.lib.storage.btrfs.mkDiskoRootDisk {
    device = "/dev/disk/by-id/nvme-KINGSTON_OM3PDP3512B-A01_50026B7685D47463";
    swapSize = "17G";
  };
  fileSystems."/run/media/${self.vars.name.user}/sdcard" = {
    device = "/dev/disk/by-id/mmc-EF8S5_0x3b3163d0-part1";
    options = [
      "defaults"
      "subvol=@"
      "compress=zstd"
      "noatime"
      "nofail"
    ];
  };
}
