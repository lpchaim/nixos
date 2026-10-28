{inputs, ...}: let
  inherit (inputs.self.lib) callPackageWith;
in {
  perSystem = {pkgs, ...}: let
    callPackage = callPackageWith pkgs;
  in {
    packages = {
      lichen = callPackage ./lichen {};
    };
  };
}
