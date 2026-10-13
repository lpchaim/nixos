{lib, ...}: {
  my.storage = {
    mergerfs.enable = true;
    zfs.enable = true;
  };

  fileSystems = {
    "/srv/tank" = {
      device = "tank";
      fsType = "zfs";
      options = [
        "defaults"
        "nofail"
        "noatime"
      ];
    };
    "/srv/hdd1" = {
      device = "/dev/disk/by-id/ata-WDC_WD40EZRZ-00GXCB0_WD-WCC7K5FR9AZE-part1";
      fsType = "ext4";
      options = [
        "defaults"
        "nofail"
        "noatime"
      ];
    };
    "/srv/storage" = rec {
      device = lib.concatStringsSep ":" depends;
      fsType = "mergerfs";
      depends = [
        "/srv/tank"
        "/srv/hdd1"
      ];
      options = [
        "defaults"
        "nofail"
        "cache.files=off"
        "category.create=eppfrd"
        "dropcacheonclose=false"
        "export-support=true"
        "fsname=mergerfs"
        "func.getattr=newest"
        "inodecalc=path-hash"
        "ignorepponrename=true"
        "minfreespace=50G"
        "nonempty"
        "passthrough.io=rw"
        "xattr=passthrough"
      ];
    };
  };
}
