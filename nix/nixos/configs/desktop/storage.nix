{self, ...}: {
  disko.devices.disk.main = self.lib.storage.btrfs.mkDiskoRootDisk {
    device = "/dev/disk/by-id/nvme-Corsair_MP600_PRO_XT_214279380001310131BD";
    swapSize = "35G";
  };
  fileSystems."/run/media/${self.vars.name.user}/storage" = {
    device = "/dev/disk/by-id/ata-ADATA_SU630_2J0220042661-part1";
    fsType = "btrfs";
    options = [
      "defaults"
      "auto"
      "exec"
      "nofail"
      "nosuid"
      "nodev"
      "noatime"
      "compress=zstd"
      "x-gvfs-show"
    ];
  };
}
