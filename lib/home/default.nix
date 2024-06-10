{ lib, ... }:

{
  home = {
    getTraitModules = traits:
      map (mod: lib.snowfall.fs.get-file "modules/home/traits/${mod}.nix") traits;
  };
}
