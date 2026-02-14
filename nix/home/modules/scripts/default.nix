{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  cfg = config.my.scripts;
in {
  options.my.scripts = {
    enable = lib.mkEnableOption "scripts";
    byName = lib.mkOption {
      default = inputs.self.legacyPackages.${system}.scripts;
    };
    packages = lib.mkOption {
      default = builtins.attrValues cfg.byName;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = cfg.packages;
    home.file = let
      inherit (inputs.self.lib) carapaceSpecFromNuScript;
      specPath = ".config/carapace/specs";
    in
      lib.mkIf config.programs.carapace.enable
      (
        cfg.byName
        |> lib.filterAttrs (_: script: lib.strings.hasInfix "/bin/nu" script.interpreter)
        |> lib.concatMapAttrs
        (name: script: {
          "${specPath}/${name}.yaml".source = carapaceSpecFromNuScript script;
        })
      );
  };
}
