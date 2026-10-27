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
      channels = {inherit (self.inputs) nixpkgs stable unstable;};
      extraOptions = ''
        !include ${config.my.secrets."nix-extra-access-tokens".path}
      '';
      gc.automatic = osConfig == {};
      nixPath = ["$HOME/.nix-defexpr/channels"];
      registry =
        lib.mapAttrs (name: channel: {
          from = {
            type = "indirect";
            id = name;
          };
          to = {
            type = "path";
            path = channel;
          };
        })
        config.nix.channels;
      settings = lib.mkIf isLix {repl-overlays = ["repl-overlay.nix"];};
    };

    nixpkgs = lib.mkIf (osConfig == {}) nix.pkgs;

    home = {
      packages = [config.nix.package pkgs.sqlite];
      sessionVariables = {
        FLAKE_PATH = lib.replaceString "~" config.home.homeDirectory self.vars.flake.path;
        SYSTEM = pkgs.stdenv.hostPlatform.system;
      };
      file =
        (lib.mapAttrs' (name: channel: {
            name = "${config.home.homeDirectory}/.nix-defexpr/channels/${name}";
            value = {
              source = channel;
              force = true;
            };
          })
          config.nix.channels)
        // {
          "${config.xdg.configHome}/nix/repl-overlay.nix" = lib.mkIf isLix {source = ./repl-overlay.nix;};
        };
    };
  };
}
