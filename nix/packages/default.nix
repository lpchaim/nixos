args: let
  inherit ((import ../lib args).loaders) callPackageNonDefault;
in {
  imports = [
    ./scripts
  ];

  perSystem = {self', ...}: let
    inherit (self'.legacyPackages) pkgs;
  in {
    packages = callPackageNonDefault ./. pkgs;
  };
}
