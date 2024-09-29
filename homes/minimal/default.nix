{
  lib,
  pkgs,
  ...
} @ args: let
  inherit (lib.lpchaim.home) getTraitModules;
  inherit (lib.snowfall) module;
  homeModules = lib.pipe ../../modules/home [
    (src: module.create-modules {inherit src;})
    builtins.attrValues
  ];
in {
  imports =
    homeModules
    ++ (getTraitModules [
      "non-nixos"
    ]);

  config = {
    home = {
      inherit (args) homeDirectory stateVersion username;
    };
    nix.package = pkgs.nix;
  };
}
