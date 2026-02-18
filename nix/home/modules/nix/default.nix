{
  config,
  inputs,
  lib,
  osConfig ? {},
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
      extraOptions = ''
        !include ${config.my.secrets."nix-extra-access-tokens".path}
      '';
      gc.automatic = osConfig == {};
    };

    nixpkgs = lib.mkIf (osConfig == {}) nix.pkgs;
  };
}
