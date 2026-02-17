{
  config,
  inputs,
  lib,
  osConfig ? {},
  pkgs,
  ...
}: let
  inherit (config.my.config) nix;
  inherit (inputs.self.lib.secrets.helpers) mkSecret;
  cfg = config.my.nix;
in {
  options.my.nix.enable = lib.mkEnableOption "nix";

  config = lib.mkIf (cfg.enable) {
    my.secretDefinitions = {
      "nix-extra-access-tokens" = mkSecret "nix-extra-access-tokens" {};
    };

    nix = {
      inherit (nix) settings;
      extraOptions = ''
        !include ${config.my.secrets."nix-extra-access-tokens".path}
      '';
      gc = {
        automatic = osConfig == {};
        dates = "daily";
        options = "--delete-older-than 7d";
      };
      package = lib.mkForce (osConfig.nix.package or pkgs.lixPackageSets.stable.lix);
    };

    nixpkgs = lib.mkIf (osConfig == {}) {
      inherit (nix.pkgs) config;
      overlays = builtins.attrValues inputs.self.overlays;
    };
  };
}
