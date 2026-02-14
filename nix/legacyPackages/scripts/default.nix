args: let
  inherit ((import ../../lib args).loaders) loadNonDefault;
in {
  # For reasons beyond my understanding, removing an argument from the attribute
  # set here stops it from propagating to the loaded files even if the whole
  # systemArgs is used as an argument
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
