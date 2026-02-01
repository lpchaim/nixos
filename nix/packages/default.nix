{...}: let
  inherit (import ../lib) mkPkgs;
in {
  perSystem = {
    inputs',
    self',
    lib,
    system,
    ...
  }: let
    inherit (self'.legacyPackages) pkgs;
  in {
    packages = let
      callPackage = lib.callPackageWith pkgs;
    in {
      lichen =
        callPackage
        ./lichen/package.nix
        {inherit (inputs'.nixpkgs-hare.legacyPackages) hare hareHook;};
    };
  };
}
