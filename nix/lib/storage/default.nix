{lib, ...} @ args: {
  btrfs = import ./btrfs.nix args;
  ntfs = import ./ntfs.nix;

  mkSafePath = path:
    path
    |> lib.strings.removePrefix "/"
    |> builtins.replaceStrings ["/"] ["-"];
}
