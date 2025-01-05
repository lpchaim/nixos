{
  inputs,
  lib,
  ...
} @ args: let
  inherit (import ./. args) mkPreMountFsck;
in {
  mkSecondaryStorage = {
    device,
    mountPoint,
    fsck ? true,
    system ? "x86_64-linux",
  }:
    {
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
    }
    // lib.optionalAttrs fsck (mkPreMountFsck {
      inherit device mountPoint;
      command = "${inputs.self.pkgs.${system}.ntfs3g}/bin/ntfsfix ${device} --clear-dirty";
    });
}
