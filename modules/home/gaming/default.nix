{
  config,
  lib,
  pkgs,
  ...
} @ args: let
  inherit (lib) mkIf mkMerge;
in
  lib.lpchaim.mkModule {
    inherit config;
    description = "gaming config";
    namespace = "my.modules.gaming";
    configBuilder = cfg:
      mkMerge [
        (mkIf (args ? osConfig && args.osConfig.programs.steam.enable) {
          home.file =
            lib.concatMapAttrs
            (_: package: {
              ".local/share/Steam/compatibilitytools.d/${package.version}".source = "${package.steamcompattool}";
            })
            pkgs.proton-ge-bin-versions;
        })
      ];
  }
