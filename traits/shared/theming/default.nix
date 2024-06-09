{ lib, pkgs, ... }:

with lib;
{
  stylix = {
    autoEnable = mkDefault true;
    image = mkDefault "${../../../assets/wallpaper-city-d.png}";
    polarity = mkDefault "dark";
    base16Scheme = mkDefault "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    fonts.monospace = mkDefault {
      name = mkDefault "JetBrainsMono";
      package = mkDefault (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });
    };
  };
}
