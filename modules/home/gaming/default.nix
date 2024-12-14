{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkMerge;
in
  lib.lpchaim.mkModule {
    inherit config;
    description = "gaming config";
    namespace = "my.modules.gaming";
    configBuilder = cfg:
      mkMerge [
        (mkIf (osConfig.programs.steam.enable or false) {
          home.file =
            lib.concatMapAttrs
            (_: package: {
              ".local/share/Steam/compatibilitytools.d/${package.version}".source = "${package.steamcompattool}";
            })
            pkgs.proton-ge-bin-versions;
        })
      ];
  }
