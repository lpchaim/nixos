{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.self.lib.config.nix) settings;
in {
  nix = {
    inherit settings;
    gc = {
      automatic = lib.mkDefault true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    package = lib.mkForce pkgs.lixPackageSets.stable.lix;
  };
}
