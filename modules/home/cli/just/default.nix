{ config, lib, pkgs, ... }:

let
  namespace = [ "my" "modules" "cli" "just" ];
  cfg = lib.getAttrFromPath namespace config;
in
{
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "just";
  };

  config = lib.mkIf cfg.enable {
    home =
      let
        rootDir = "${config.home.homeDirectory}/.config/nixos";
      in
      {
        packages = [ pkgs.just ];
        file."${rootDir}/.justfile".text = lib.pipe ./justfile [
          (file: pkgs.writeText "formatted-justfile" ''
            cp $src ./justfile
            chmod +rw ./justfile;
            ${lib.getExe pkgs.just} --unstable --fmt --justfile ./justfile
            cat ./justfile > $out
            chmod +rw $out;
          '')
          builtins.readFile
        ];
        shellAliases."just" = lib.concatStringsSep " " [
          (lib.getExe pkgs.just)
          "--working-directory ${rootDir}"
          "--justfile ${rootDir}/.justfile"
        ];
      };
  };
}
