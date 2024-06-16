{ lib, ... }:

{
  nixos = {
    getTraitModules = traits:
      map (mod: lib.snowfall.fs.get-file "modules/nixos/traits/${mod}.nix") traits;
  };
}