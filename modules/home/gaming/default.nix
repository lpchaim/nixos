{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  cfg = config.my.modules.gaming;
in {
  options.my.modules.gaming.enable = lib.mkEnableOption "gaming tweaks";
  config = mkIf (cfg.enable && osConfig != null && osConfig.programs.steam.enable) {
    home.file =
      lib.concatMapAttrs
      (_: package: {
        ".local/share/Steam/compatibilitytools.d/${package.version}".source = "${package.steamcompattool}";
      })
      pkgs.proton-ge-bin-versions;
  };
}
