# Use the GNOME desktop environment
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.profiles.de.gnome;
in {
  options.my.profiles.de.gnome = lib.mkEnableOption "gnome profile";
  config = lib.mkIf cfg {
    services.xserver.enable = true;
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = let
      getPackages = p: (builtins.filter (package: p ? package) (with p; [
        aisleriot # patience game
        atomix # puzzle game
        cheese # webcam tool
        # epiphany # web browser
        # evince # document viewer
        geary # email reader
        gedit # text editor
        gnome-initial-setup
        gnome-music
        gnome-terminal
        hitori # sudoku game
        iagno # go game
        tali # poker game
        totem # video player
        five-or-more # game
        four-in-a-row # game
        gnome-chess # chess game
        gnome-mines # mine game
        gnome-software
        gnome-sound-recorder
        gnome-sudoku # sudoku game
        gnome-system-monitor
        gnome-taquin # game
        gnome-tetravex # tetris game
        hitori # game
        quadrapassel # tetris game
        sushi # nautilus previewer
        swell-foop # puzzle game
      ]));
    in
      (getPackages pkgs)
      ++ (getPackages pkgs.gnome);
    environment.systemPackages = with pkgs; [
      gnome-photos
    ];
  };
}
