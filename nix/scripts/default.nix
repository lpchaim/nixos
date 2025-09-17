args: let
  inherit ((import ../lib args).loaders) loadNonDefault;
in {
  perSystem = {
    self',
    pkgs,
    ...
  } @ systemArgs: {
    legacyPackages = let
      scripts = loadNonDefault ./. systemArgs;
    in
      scripts # Provide them at the top level as well so they're more convenient to run
      // {inherit scripts;};
  };
}
