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
        bottles
        libreoffice-qt6-fresh
        obsidian
        signal-desktop
        vesktop
        zapzap
      ];

      home.file = let
        inherit (inputs.self.lib.config) profilePicture wallpaper;
      in {
        "${config.home.homeDirectory}/.face".source = profilePicture;
        "${config.xdg.userDirs.pictures}/Wallpapers/${builtins.baseNameOf wallpaper}".source = wallpaper;
      };

      programs = {
        vscode = {
          enable = true;
          package = pkgs.vscode.fhs;
          profiles.default.enableExtensionUpdateCheck = true;
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

      services.flatpak = {
        overrides.global.Environment.XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
        packages = [
          "com.fightcade.Fightcade"
          "com.github.tchx84.Flatseal"
        ];
        uninstallUnmanaged = false;
        update.auto.enable = true;
      };
    }
  ]);
}
