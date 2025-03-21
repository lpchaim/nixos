{
  config,
  lib,
  pkgs,
  ...
}: let
  matchTheme = theme:
    lib.pipe config.stylix.base16Scheme [
      builtins.toString
      (builtins.match "^.*/themes/.*${theme}.*$")
    ];
in
  lib.mkIf config.stylix.enable (lib.mkMerge [
    {
      home.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
      ];
      stylix.targets.mangohud.enable = false;
      stylix.targets.firefox.profileNames = ["default"];
      stylix.targets.vscode.profileNames = ["default"];
    }
    (lib.mkIf (matchTheme "catppuccin" != null) {
      programs.helix.settings.theme = lib.mkForce "catppuccin_mocha";
    })
  ])
