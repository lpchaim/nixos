{
  config,
  inputs,
  lib,
  osConfig ? {},
  pkgs,
  ...
}: let
  inherit (inputs.self.lib.config) nix;
  cfg = config.my.nix;
in {
  options.my.nix.enable = lib.mkEnableOption "nix";
  config = lib.mkIf (cfg.enable) {
    nix =
      {
        inherit (nix) settings;
        gc = {
          automatic = osConfig == {};
          dates = "daily";
          options = "--delete-older-than 7d";
        };
        package = lib.mkForce (osConfig.nix.package or pkgs.lixPackageSets.stable.lix);
      }
      // (lib.optionalAttrs (osConfig != {}) {
        inherit (osConfig.nix) extraOptions;
      });
    nixpkgs = lib.mkIf (osConfig == {}) {
      inherit (nix.pkgs) config;
      overlays = builtins.attrValues inputs.self.overlays;
    };
  };
}
