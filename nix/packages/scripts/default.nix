args: let
  inherit ((import ../../lib args).loaders) loadNonDefault;
in {
  perSystem = {
    self',
    pkgs,
    ...
  } @ systemArgs: {
    legacyPackages = let
      scripts = loadNonDefault ./. systemArgs;
    in
      scripts
      // {inherit scripts;};
  };
}
