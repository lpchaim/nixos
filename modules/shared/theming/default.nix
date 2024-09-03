{
  config,
  lib,
  pkgs,
  ...
}: {
  stylix = rec {
    enable = lib.mkDefault true;
    autoEnable = lib.mkDefault true;
    image = lib.mkDefault (
      if polarity != "light"
      then ../../assets/wallpaper-dark.png
      else ../../assets/wallpaper-light.png
    );
    polarity = lib.mkDefault "dark";
    base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    cursor = {
      name = "catppuccin-latte-light-cursors";
      package = pkgs.catppuccin-cursors.latteLight;
      size = 32;
    };
    fonts.monospace = lib.mkDefault {
      name = lib.mkDefault "JetBrainsMono Nerd Font";
      package = lib.mkDefault (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];});
    };
  };
}
