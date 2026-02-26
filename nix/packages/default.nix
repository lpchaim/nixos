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
      libfprint-canvasbio-cb2000 = callPackage ./libfprint-canvasbio-cb2000 {};
      lichen = callPackage ./lichen {inherit (inputs'.nixpkgs-hare.legacyPackages) hare hareHook;};
    };
  };
}
