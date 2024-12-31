{
  config,
  lib,
  ...
}: let
  cfg = config.my.traits.non-nixos;
in {
  options.my.traits.non-nixos.enable = lib.mkEnableOption "Non-NixOS machine trait";
  config = lib.mkIf cfg.enable {
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
  };
}
