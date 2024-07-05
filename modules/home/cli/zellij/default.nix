{ config, inputs, lib, ... }:

let
  inherit (lib) getAttrFromPath
    mkEnableOption
    mkForce
    mkMerge
    setAttrByPath;
  inherit (inputs.home-manager.lib.hm.generators) toKDL;
  namespace = [ "my" "modules" "cli" "zellij" ];
  cfg = getAttrFromPath namespace config;
in
{
  options = setAttrByPath namespace {
    enable = mkEnableOption "zellij";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      zellij = {
        enable = true;
      };
    };

    # Not the most elegant solution, but seeing as how the HM module doesn't yet
    # support something like programs.zellij.extraConfig, it'll have to do
    home.file."${config.xdg.configHome}/zellij/config.kdl".text = mkForce ''
      ${builtins.readFile ./config.kdl}

      // Home Manager settings
      ${toKDL {} config.programs.zellij.settings}
    '';
  };
}
