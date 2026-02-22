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
      (lib.packagesFromDirectoryRecursive {
          inherit callPackage;
          directory = ./.;
        }
        |> lib.filterAttrs (name: _: name != "default"))
      // {
        lichen =
          callPackage
          ./lichen/package.nix
          {inherit (inputs'.nixpkgs-hare.legacyPackages) hare hareHook;};
      };
  };
}
