{
  config,
  lib,
  osConfig ? {},
  pkgs,
  self,
  ...
}: let
  inherit (self.lib.secrets.helpers) mkSecret;
  inherit (self.vars) nix;
  cfg = config.my.nix;
  isLix = lib.hasPrefix "lix" config.nix.package.name;
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
      settings = lib.mkIf isLix {repl-overlays = ["repl-overlay.nix"];};
    };

    nixpkgs = lib.mkIf (osConfig == {}) nix.pkgs;

    home = {
      sessionVariables = {
        FLAKE_PATH = lib.replaceString "~" config.home.homeDirectory self.vars.flake.path;
        SYSTEM = pkgs.stdenv.hostPlatform.system;
      };
      file = lib.mkIf isLix {
        "${config.xdg.configHome}/nix/repl-overlay.nix".source = ./repl-overlay.nix;
      };
    };
  };
}
