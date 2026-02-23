{...}: {
  perSystem = {
    inputs',
    lib,
    pkgs,
    ...
  }: let
    callPackage = lib.callPackageWith pkgs;
  in {
    packages =
      lib.packagesFromDirectoryRecursive {
        inherit callPackage;
        directory = ./.;
      }
      |> lib.filterAttrsRecursive (name: _: name != "default")
      |> lib.recursiveUpdate {
        lichen =
          callPackage
          ./lichen/package.nix
          {inherit (inputs'.nixpkgs-hare.legacyPackages) hare hareHook;};
      };
  };
}
