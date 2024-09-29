{
  config,
  lib,
  ...
}: let
  matchTheme = theme:
    lib.pipe config.stylix.base16Scheme [
      builtins.toString
      (builtins.match "^.*/themes/.*${theme}.*$")
    ];
in
  lib.mkIf config.stylix.enable (lib.mkMerge [
    {stylix.targets.mangohud.enable = false;}
    (lib.mkIf (matchTheme "catppuccin" != null) {
      programs.helix.settings.theme = lib.mkForce "catppuccin_mocha";
    })
  ])
