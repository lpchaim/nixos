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
in {
  config = let
    themeOverrides = lib.mkMerge [
      (lib.mkIf (matchTheme "catppuccin" != null) {
        programs.helix.settings.theme = lib.mkForce "catppuccin_mocha";
      })
    ];
  in
    lib.mkIf config.stylix.enable themeOverrides;
}
