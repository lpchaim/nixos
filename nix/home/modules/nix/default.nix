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
          frequency = "daily";
          options = "--delete-older-than 7d";
        };
        package = lib.mkForce (osConfig.nix.package or pkgs.nix);
      }
      // (lib.optionalAttrs (osConfig != {}) {
        inherit (osConfig.nix) extraOptions;
      });
    nixpkgs = lib.mkIf (osConfig == {} || !osConfig.home-manager.useGlobalPkgs) {
      config =
        nix.pkgs.config
        // {enableCuda = osConfig.nix.config.enableCuda or false;};
    };
  };
}
