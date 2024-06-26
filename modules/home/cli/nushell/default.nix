{ config, lib, pkgs, ... }:

let
  namespace = [ "my" "modules" "cli" "nushell" ];
  cfg = lib.getAttrFromPath namespace config;
in
{
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "nushell";
  };

  config = lib.mkIf cfg.enable {
    programs.nushell = {
      inherit (config.home) shellAliases;
      enable = true;
      extraConfig = builtins.readFile ./config.nu;
      extraEnv =
        let
          pkgToKeyVal = name: {
            inherit name;
            value = "${pkgs.${name}}/bin/${name}";
          };
          pathsPerPkg = builtins.listToAttrs
            (builtins.map pkgToKeyVal [ "git" "fzf" ]);
          patch = path:
            pkgs.runCommand "patch-commands" pathsPerPkg "substituteAll ${path} $out";
        in
        lib.concatStringsSep "\n" [
          (builtins.readFile ./env.nu)
          (builtins.readFile (patch ./commands.nu))
        ];
    };
  };
}
