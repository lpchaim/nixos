{ lib, ... }:

let
  inherit (lib.snowfall) fs;
in
{
  home = {
    getTraitModules = traits:
      map (mod: fs.get-file "modules/home/traits/${mod}.nix") traits;
  };
}
