{
  config,
  pkgs,
  lib,
  osConfig ? {},
  ...
}: let
  cfg = config.my.gui;
in {
  imports = [
    ./chromium.nix
    ./firefox.nix
    ./kitty.nix
    ./mangohud.nix
    ./media.nix
  ];

  options.my.gui.enable =
    lib.mkEnableOption "gui apps"
    // {default = osConfig.my.gui.enable or false;};

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig == {} || osConfig.hardware.graphics.enable;
        message = "config.my.gui.enable is useless without graphics";
      }
    ];

    home.packages = with pkgs; [
      element-desktop
      file-roller
      gnome-system-monitor
      libreoffice-qt6-fresh
      loupe
      nautilus
      obsidian
      pavucontrol
      qbittorrent
      signal-desktop
      vesktop
    ];

    home.file = let
      inherit (config.my.config) profilePicture wallpaper;
    in {
      "${config.home.homeDirectory}/.face".source = profilePicture;
      "${config.xdg.userDirs.pictures}/Wallpapers/${baseNameOf wallpaper}".source = wallpaper;
    };

    programs = {
      vscode = {
        enable = true;
        package = pkgs.vscode.fhs;
        profiles.default.enableExtensionUpdateCheck = true;
        mutableExtensionsDir = true;
      };
      wezterm.enable = true;
    };

    services = {
      kdeconnect = lib.mkIf (osConfig != {}) {
        inherit (osConfig.programs.kdeconnect) package;
        enable = true;
        indicator = true;
      };
      nextcloud-client = {
        enable = false;
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
      enable = osConfig == {};
      packages = ["com.github.tchx84.Flatseal"];
    };
  };
}
