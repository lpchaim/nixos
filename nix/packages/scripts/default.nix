args: let
  inherit ((import ../../lib args).loaders) callPackageNonDefault;
in {
  perSystem = {pkgs, ...}: {
    legacyPackages.scripts = callPackageNonDefault ./. pkgs;
  };
}
