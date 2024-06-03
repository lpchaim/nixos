{ config, pkgs, ... }:

{
  imports = [
    ../shared/theming
  ];

  targets.genericLinux.enable = true;
  xdg.mime.enable = true;
  xdg.systemDirs.data = [
    "${config.home.homeDirectory}/.nix-profile/share/applications"
  ];
}
