{...}: {
  perSystem = {
    inputs',
    lib,
    pkgs,
    ...
  }: let
    extraArgs = {
      inherit (inputs'.nixpkgs-hare.legacyPackages) hare hareHook;
    };
    callPackage = lib.callPackageWith (pkgs // extraArgs);
  in {
    packages =
      lib.packagesFromDirectoryRecursive {
        inherit callPackage;
        directory = ./.;
      }
      |> lib.filterAttrsRecursive (name: _: name != "default");
  };
}
