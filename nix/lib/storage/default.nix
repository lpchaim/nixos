{lib, ...}: {
  btrfs = import ./btrfs.nix;
  ntfs = import ./ntfs.nix;

  mkSafePath = path:
    lib.pipe path [
      (lib.strings.removePrefix "/")
      (builtins.replaceStrings ["/"] ["-"])
    ];
}
