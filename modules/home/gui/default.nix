{
  config,
  pkgs,
  lib,
  osConfig ? null,
  ...
}:
with lib; let
  cfg = config.my.modules.gui;
in {
  imports = [
    ./chromium.nix
    ./firefox.nix
    ./mangohud.nix
  ];

  options.my.modules.gui.enable = mkEnableOption "gui apps";

  config = mkIf cfg.enable (mkMerge [
    {my.modules.gui.firefox.enable = mkDefault true;}
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
        kdeconnect = mkIf (osConfig != null) {
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
