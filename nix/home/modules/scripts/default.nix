{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.modules.scripts;
in {
  options.my.modules.scripts = {
    enable = lib.mkEnableOption "scripts";
    byName = lib.mkOption {
      default = inputs.self.legacyPackages.${pkgs.system}.scripts;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = builtins.attrValues cfg.byName;
    home.file =
      lib.mkIf config.programs.carapace.enable
      (lib.pipe cfg.byName [
        (lib.filterAttrs
          (_: script: lib.strings.hasInfix "/bin/nu" script.interpreter))
        (lib.concatMapAttrs
          (name: script: {
            ".config/carapace/specs/${name}.yaml".source =
              pkgs.runCommand
              "nushell-carapace-spec-${name}"
              {buildInputs = [script cfg.byName.nu-generate-carapace-spec];}
              ''
                ${name} --help \
                | nu-generate-carapace-spec \
                > $out
              '';
          }))
      ]);
  };
}
