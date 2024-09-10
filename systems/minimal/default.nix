{lib, ...}: let
  inherit (lib.lpchaim.nixos) getTraitModules;
in {
  imports = getTraitModules [
    "composite/base"
  ];
}
