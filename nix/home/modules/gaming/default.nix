{
  config,
  lib,
  osConfig ? {},
  pkgs,
  ...
}: let
  cfg = config.my.modules.gaming;
in {
  options.my.modules.gaming.enable = lib.mkEnableOption "gaming tweaks";
  config = lib.mkIf (cfg.enable && osConfig != {} && osConfig.programs.steam.enable) {
    home.file =
      lib.concatMapAttrs
      (_: package: {
        ".local/share/Steam/compatibilitytools.d/${package.version}".source = "${package.steamcompattool}";
      })
      pkgs.proton-ge-bin-versions;
  };
}
