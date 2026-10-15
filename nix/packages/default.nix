{inputs, ...}: let
  inherit (inputs.self.lib) callPackageWith;
in {
  perSystem = {
    inputs',
    pkgs,
    ...
  }: let
    callPackage = callPackageWith pkgs;
  in {
    packages = {
      lichen = callPackage ./lichen {inherit (inputs'.nixpkgs-hare.legacyPackages) hare hareHook;};
    };
  };
}
