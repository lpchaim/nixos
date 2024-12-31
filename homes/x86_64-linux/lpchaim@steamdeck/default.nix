{
  my.traits = {
    de.gnome.enable = true;
    de.hyprland.enable = true;
    apps.gui.enable = true;
    apps.media.enable = true;
  };

  dconf.settings."org/gnome/shell".favorite-apps = ["steam.desktop"];

  home.stateVersion = "24.05";
}
