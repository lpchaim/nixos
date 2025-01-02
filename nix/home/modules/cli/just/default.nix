{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.modules.cli.just;
in {
  options.my.modules.cli.just = {
    enable = lib.mkEnableOption "just task runner";
    extraConfig = lib.mkOption {
      description = "extra text to append to justfile";
      type = lib.types.lines;
      default = "";
    };
  };
  config = lib.mkIf cfg.enable {
    home = {
      packages = [pkgs.just];
      file.".justfile".text = lib.trim ''
        ${builtins.readFile ./justfile}
        ${cfg.extraConfig}
      '';
      shellAliases = {
        "_just" = lib.getExe pkgs.just;
        "just" = lib.concatStringsSep " " [
          (lib.getExe pkgs.just)
          "--unstable"
          "--global-justfile"
        ];
      };
    };
  };
}
