{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.self.vars) wallpaper;
  base16 = pkgs.base16-schemes + /share/themes;
in {
  stylix = {
    enable = lib.mkDefault true;
    autoEnable = lib.mkDefault true;
    image = lib.mkDefault wallpaper;
    polarity = lib.mkDefault "dark";
    base16Scheme = lib.mkDefault "${base16}/stella.yaml";
    cursor = {
      name = "catppuccin-latte-light-cursors";
      package = pkgs.catppuccin-cursors.latteLight;
      size = 32;
    };
    fonts.monospace = {
      name = lib.mkDefault "JetBrainsMono Nerd Font";
      package = lib.mkDefault pkgs.nerd-fonts.jetbrains-mono;
    };
    fonts.sansSerif = {
      name = lib.mkDefault "Inter Variable";
      package = lib.mkDefault pkgs.inter;
    };
    fonts.serif = {
      name = lib.mkDefault "Libre Baskerville";
      package = lib.mkDefault pkgs.libre-baskerville;
    };
  };
}
