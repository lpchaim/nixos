{ config, ... }:

{
  targets.genericLinux.enable = true;

  xdg.mime.enable = true;
  xdg.systemDirs.data = [
    "${config.home.homeDirectory}/.nix-profile/share/applications"
  ];

  stylix.targets = {
    gnome.enable = false;
    gtk.enable = false;
    kde.enable = false;
    hyprland.enable = false;
  };
}
