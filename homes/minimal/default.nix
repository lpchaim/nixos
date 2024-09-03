{
  lib,
  pkgs,
  username,
  homeDirectory,
  stateVersion,
  ...
}: let
  inherit (lib.lpchaim.home) getTraitModules;
in {
  imports = getTraitModules [
    "non-nixos"
  ];

  config = {
    home = {
      inherit username homeDirectory stateVersion;
    };
    nix.package = pkgs.nix;
  };
}
