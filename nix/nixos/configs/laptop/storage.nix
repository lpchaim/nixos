{self, ...}: {
  disko.devices.disk.main = self.lib.storage.btrfs.mkDiskoRootDisk {
    device = "/dev/disk/by-id/nvme-WDSN740-SDDPNQD-512G-1004_23360G804890";
    swapSize = "17G";
  };
}
