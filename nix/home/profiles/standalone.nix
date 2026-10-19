{
  config,
  lib,
  osConfig ? {},
  ...
}: let
  cfg = config.my.profiles.standalone;
in {
  options.my.profiles.standalone =
    lib.mkEnableOption "standalone/non-NixOS profile"
    // {default = osConfig == {};};

  config = lib.mkIf cfg {
    home.sessionVariables.BACKUP_EXTENSION = "backup";

    targets.genericLinux.enable = true;

    xdg.mime.enable = false;
    xdg.systemDirs.data = [
      "${config.home.homeDirectory}/.nix-profile/share/applications"
    ];

    stylix.targets = {
      gnome.enable = false;
      gtk.enable = false;
      kde.enable = false;
      hyprland.enable = false;
    };
  };
}
