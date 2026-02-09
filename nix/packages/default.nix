args: let
  inherit ((import ../lib args).loaders) callPackageDefault callPackageNonDefault;
in {
  perSystem = {
    inputs',
    self',
    lib,
    system,
    ...
  }: let
    inherit (self'.legacyPackages) pkgs;
    callPackage = lib.callPackageWith pkgs;
  in {
    packages =
      (callPackageDefault ./. pkgs)
      // (callPackageNonDefault ./. pkgs)
      // {
        lichen =
          callPackage
          ./lichen/package.nix
          {inherit (inputs'.nixpkgs-hare.legacyPackages) hare hareHook;};
      };
  };
}
