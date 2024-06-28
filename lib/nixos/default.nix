{ lib, ... }:

let
  inherit (lib.snowfall) fs;
in
{
  nixos = {
    getTraitModules = traits:
      map (mod: fs.get-file "modules/nixos/traits/${mod}.nix") traits;
  };
}
