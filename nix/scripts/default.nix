args: let
  inherit ((import ../lib args).loaders) loadNonDefault;
in {
  # imports = listNonDefault ./.;
  perSystem = {pkgs, ...} @ args: {
    legacyPackages.scripts = loadNonDefault ./. args;
  };
}
