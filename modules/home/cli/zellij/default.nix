{ config, inputs, lib, ... }:

let
  inherit (lib) getAttrFromPath
    mkEnableOption
    mkForce
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
        settings = {
          session_serialization = true;
          pane_viewport_serialization = true;
          serialize_pane_viewport = true;
          scrollback_lines_to_serialize = 10000;
          scroll_buffer_size = 10000;
          copy_clipboard = "primary";
          pane_frames = true;
          ui.pane_frames = {
            rounded_corners = true;
            hide_session_name = false;
          };
        };
      };
    };

    # Not the most elegant solution, but seeing as how the HM module doesn't yet
    # support something like programs.zellij.extraConfig, it'll have to do
    home.file."${config.xdg.configHome}/zellij/config.kdl" = mkForce {
      text = ''
        ${builtins.readFile ./config.kdl}

        // Home Manager settings
        ${toKDL {} config.programs.zellij.settings}
      '';
    };
  };
}
