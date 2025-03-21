{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkForce;
  inherit (inputs.home-manager.lib.hm.generators) toKDL;
  cfg = config.my.modules.cli.zellij;
in {
  options.my.modules.cli.zellij.enable = mkEnableOption "zellij";

  config = lib.mkIf cfg.enable {
    programs = {
      zellij = {
        enable = true;
        enableBashIntegration = false;
        enableFishIntegration = false;
        enableZshIntegration = false;
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
