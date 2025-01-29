args: let
  inherit ((import ../../lib args).loaders) loadNonDefault;
in {
  perSystem = {pkgs, ...} @ args: {
    legacyPackages.scripts = loadNonDefault ./. args;
  };
}
