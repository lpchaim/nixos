{ lib, pkgs, ... }:

with lib;
{
  stylix = rec {
    enable = mkDefault true;
    autoEnable = mkDefault true;
    image = mkDefault (
      if polarity != "light" then ../../assets/wallpaper-dark.png
      else ../../assets/wallpaper-light.png
    );
    polarity = mkDefault "dark";
    base16Scheme = mkDefault "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    cursor = {
      name = "catppuccin-latte-light-cursors";
      package = pkgs.catppuccin-cursors.latteLight;
      size = 32;
    };
    fonts.monospace = mkDefault {
      name = mkDefault "JetBrainsMono";
      package = mkDefault (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });
    };
  };
}
