{ config, lib, pkgs, ... }:

lib.lpchaim.mkModule {
  inherit config;
  namespace = "my.modules.cli.just";
  description = "just task runner";
  options = {
    extraConfig = lib.mkOption {
      description = "extra text to append to justfile";
      type = lib.types.string;
      default = "";
    };
  };
  configBuilder = cfg: {
    home = {
      packages = [ pkgs.just ];
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
