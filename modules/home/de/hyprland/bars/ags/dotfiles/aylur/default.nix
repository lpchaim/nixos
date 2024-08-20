{ config, inputs, lib, pkgs, ... }:

lib.lpchaim.mkModule {
  inherit config;
  description = "aylur's ags dotfiles";
  namespace = "my.modules.de.hyprland.bars.ags.dotfiles.aylur";
  configBuilder = cfg: lib.mkIf cfg.enable {
    programs.ags.package = pkgs.callPackage ./ags.nix { inherit inputs; };
    home.file.".config/background".source = config.stylix.image;
  };
}
