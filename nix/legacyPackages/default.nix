args: {
  perSystem = {
    lib,
    self',
    pkgs,
    ...
  }: let
    extraArgs = {
      inherit (args) inputs;
      inherit (self'.legacyPackages.pkgs) writeNuScriptStdinBin;
    };
    callPackage = lib.callPackageWith (pkgs // extraArgs);
  in {
    legacyPackages =
      lib.packagesFromDirectoryRecursive {
        inherit callPackage;
        directory = ./.;
      }
      |> lib.filterAttrsRecursive (name: _: name != "default")
      |> (legacyPackages: legacyPackages // legacyPackages.scripts);
  };
}
