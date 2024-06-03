{ lib, pkgs, ... }:

{
  stylix = {
    image = lib.mkDefault ../../../assets/wallpaper-city-d.png;
    polarity = lib.mkDefault "dark";
    base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    fonts.monospace = {
      name = "JetBrainsMono";
      package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });
    };
  };
}
