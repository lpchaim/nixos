{
  config,
  inputs,
  pkgs,
  lib,
  osConfig ? {},
  ...
}: let
  inherit (inputs.self.lib.loaders) listNonDefault;
  cfg = config.my.modules.gui;
in {
  imports = listNonDefault ./.;

  options.my.modules.gui.enable = lib.mkEnableOption "gui apps";

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      home.packages = with pkgs; [
        logseq
        spotify-tray
        zapzap
        vesktop
      ];

      programs = {
        vscode = {
          enable = true;
          package = pkgs.vscode.fhs;
          enableExtensionUpdateCheck = true;
          mutableExtensionsDir = true;
        };
      };

      services = {
        kdeconnect = lib.mkIf (osConfig != {}) {
          inherit (osConfig.programs.kdeconnect) package;
          enable = true;
          indicator = true;
        };
        nextcloud-client = {
          enable = true;
          startInBackground = true;
        };
        trayscale = {
          enable = true;
          hideWindow = true;
        };
      };

      xdg.mime.enable = true;
      xdg.systemDirs.data = [
        "${config.home.homeDirectory}/.nix-profile/share/applications"
      ];
    }
  ]);
}
