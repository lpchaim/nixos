{lib, ...}: {
  imports = lib.pipe ./. [
    lib.filesystem.listFilesRecursive
    (builtins.filter (path: ! (lib.hasSuffix "default.nix" path)))
  ];
}
