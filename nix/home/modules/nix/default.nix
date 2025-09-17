{
  config,
  inputs,
  lib,
  osConfig ? {},
  pkgs,
  ...
}: let
  inherit (inputs.self.lib.config) nix;
  cfg = config.my.modules.nix;
in {
  options.my.modules.nix.enable = lib.mkEnableOption "nix";
  config = lib.mkIf (cfg.enable) {
    nix =
      {
        inherit (nix) settings;
        gc = {
          automatic = osConfig == {};
          dates = "daily";
          options = "--delete-older-than 7d";
        };
        package = lib.mkForce (osConfig.nix.package or pkgs.nix);
      }
      // (lib.optionalAttrs (osConfig != {}) {
        inherit (osConfig.nix) extraOptions;
      });
    nixpkgs = lib.mkIf (osConfig == {}) {
      config =
        nix.pkgs.config
        // {cudaSupport = osConfig.nix.config.cudaSupport or false;};
      overlays = builtins.attrValues inputs.self.overlays;
    };
  };
}
