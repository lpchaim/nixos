{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  namespace = ["my" "modules" "gui"];
  cfg = getAttrFromPath namespace config;
in {
  imports = [
    ./chromium.nix
    ./firefox.nix
    ./mangohud.nix
  ];

  options = setAttrByPath namespace {
    enable = mkEnableOption "gui apps";
  };

  config = mkIf cfg.enable (mkMerge [
    (setAttrByPath namespace {
      firefox.enable = mkDefault true;
    })
    {
      home.packages = with pkgs; [
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
