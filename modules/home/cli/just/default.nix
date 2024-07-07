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
        concat = lib.concatStringsSep " ";
      in
      {
        packages = [ pkgs.just ];
        file."${rootDir}/.justfile".text = lib.pipe ./justfile [
          (file: pkgs.stdenvNoCC.mkDerivation {
            pname = "formatted-justfile";
            version = "0.0.1";

            src = file;
            dontUnpack = true;

            buildPhase = ''
              cp $src ./justfile
              chmod +rw ./justfile;
              ${lib.getExe pkgs.just} --unstable --fmt --justfile ./justfile
              cat ./justfile > $out
              chmod +rw $out;
            '';
          })
          builtins.readFile
          (
            let
              inherit (lib.lpchaim.shared.nix.settings)
                extra-trusted-public-keys
                extra-substituters;
              inherit (lib.lpchaim.strings) replaceUsing;
            in
            replaceUsing {
              "@extraSubstituters@" = concat extra-substituters;
              "@extraTrustedPublicKeys@" = concat extra-trusted-public-keys;
            }
          )
        ];
        shellAliases."just" = lib.concatStringsSep " " [
          (lib.getExe pkgs.just)
          "--working-directory ${rootDir}"
          "--justfile ${rootDir}/.justfile"
        ];
      };
  };
}
