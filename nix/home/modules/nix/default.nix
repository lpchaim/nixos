{
  config,
  lib,
  osConfig ? {},
  self,
  ...
}: let
  inherit (self.lib.secrets.helpers) mkSecret;
  inherit (self.vars) nix;
  cfg = config.my.nix;
in {
  options.my.nix.enable = lib.mkEnableOption "nix";

  config = lib.mkIf (cfg.enable) {
    my.secret.definitions = {
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
