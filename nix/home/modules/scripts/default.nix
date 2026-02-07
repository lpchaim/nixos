{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;
  inherit (pkgs.stdenv.hostPlatform) system;
  cfg = config.my.scripts;
in {
  options.my.scripts = {
    enable = lib.mkEnableOption "scripts";
    byName = lib.mkOption {
      default = inputs.self.legacyPackages.${system}.scripts;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = builtins.attrValues cfg.byName;
    home.file =
      lib.mkIf config.programs.carapace.enable
      (
        cfg.byName
        |> (lib.filterAttrs (_: script: lib.strings.hasInfix "/bin/nu" script.interpreter))
        |> (
          lib.concatMapAttrs
          (name: script: {
            ".config/carapace/specs/${name}.yaml".source =
              pkgs.runCommand
              "nushell-carapace-spec-${name}"
              {
                buildInputs = with cfg.byName; [
                  nu-generate-carapace-spec
                  nu-inspect
                ];
              }
              ''
                cat '${getExe script}' \
                | nu-inspect --name $name \
                | nu-generate-carapace-spec \
                > $out
              '';
          })
        )
      );
  };
}
