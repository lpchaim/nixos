{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.modules.de.hyprland.bars.ags.dotfiles.aylur;
in {
  options.my.modules.de.hyprland.bars.ags.dotfiles.aylur.enable = lib.mkEnableOption "aylur's ags dotfiles";
  config = lib.mkIf cfg.enable {
    programs.ags.package = pkgs.callPackage ./ags.nix {inherit inputs;};
    home.file.".config/background".source = config.stylix.image;
  };
}
