{
  config,
  lib,
  pkgs,
  ...
}:
lib.lpchaim.mkModule {
  inherit config;
  namespace = "my.modules.cli.atuin";
  description = "atuin";
  configBuilder = cfg: {
    programs.mcfly.enable = lib.mkForce false;
    programs.atuin = {
      enable = true;
      settings = {
        keymap_mode = "vim-insert";
        keymap_cursor.vim_insert = "steady-bar";
        keymap_cursor.vim_normal = "steady-block";
        history_format = "{time}  {host}  {directory}  {command}";
        filter_mode = "global";
        search_mode = "fuzzy";
        filter_mode_shell_up_key_binding = "host";
        search_mode_shell_up_key_binding = "prefix";
        sync_frequency = "15m";
        workspaces = true;
      };
    };
  };
}
