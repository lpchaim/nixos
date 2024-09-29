{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  namespace = ["my" "modules" "cli" "nushell"];
  cfg = lib.getAttrFromPath namespace config;
in {
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "nushell";
  };

  config = lib.mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      configFile.source = ./config.nu;
      envFile.source = let
        pkgToKeyVal = name: {
          inherit name;
          value = "${pkgs.${name}}/bin/${name}";
        };
        pathsPerPkg =
          builtins.listToAttrs
          (builtins.map pkgToKeyVal ["git" "fzf"]);
      in
        pkgs.runCommandNoCC "nushell-env" pathsPerPkg ''
          substituteAll ${./commands.nu} $out
          cat ${./env.nu} \
          ${inputs.nu-scripts}/modules/formats/from-env.nu \
          >> $out
        '';
      shellAliases =
        config.programs.bash.shellAliases
        // config.home.shellAliases
        // {
          ls = "ls";
          la = "ls -a";
          ll = "ls -l";
          lla = "ls -la";
        };
    };
  };
}
