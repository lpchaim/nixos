args: let
  inherit ((import ../lib args).loaders) callPackageNonDefault;
in {
  imports = [
    ./scripts
  ];

  perSystem = {pkgs, ...}: {
    packages = callPackageNonDefault ./. pkgs;
  };
}
