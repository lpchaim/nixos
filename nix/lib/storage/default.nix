{lib, ...} @ args: rec {
  btrfs = import ./btrfs.nix;
  ntfs = import ./ntfs.nix args;

  mkSafePath = path:
    lib.pipe path [
      (lib.strings.removePrefix "/")
      (builtins.replaceStrings ["/"] ["-"])
    ];
  mkPreMountFsck = {
    device,
    mountPoint,
    command,
  }: let
    safePath = mkSafePath mountPoint;
  in {
    systemd.services."mount-fsck-${safePath}" = {
      description = "Checks NTFS device ${device} before mounting";
      before = ["${safePath}.mount"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = command;
      };
    };
  };
}
