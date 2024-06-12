{ lib, ... }:

let
  inherit (lib.lpchaim.home) getTraitModules;
in
{
  imports = getTraitModules [
    "non-nixos"
    "work"
  ];

  config.home = rec {
    stateVersion = "23.05";
    username = "cheina";
    homeDirectory = "/home/${username}";
  };
}
