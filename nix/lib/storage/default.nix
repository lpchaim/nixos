{lib, ...}: {
  btrfs = import ./btrfs.nix;
  ntfs = import ./ntfs.nix;

  mkSafePath = path:
    path
    |> (lib.strings.removePrefix "/")
    |> (builtins.replaceStrings ["/"] ["-"]);
}
