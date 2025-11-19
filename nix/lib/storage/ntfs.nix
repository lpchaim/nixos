{
  mkSecondaryStorage = {
    device,
    mountPoint,
  }: {
    fileSystems.${mountPoint} = {
      inherit device;
      fsType = "ntfs3";
      options = [
        "defaults"
        "auto"
        "exec"
        "nofail"
        "nosuid"
        "nodev"
        "relatime"
        "uid=1000"
        "gid=1000"
        "iocharset=utf8"
        "x-gvfs-show"
      ];
    };
  };
}
