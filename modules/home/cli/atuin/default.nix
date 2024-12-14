{
  config,
  lib,
  osConfig ? null,
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
        daemon.enabled = true;
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
    systemd.user.services =
      {
        atuin-daemon = {
          Install.WantedBy = ["multi-user.target"];
          Service = {
            ExecStart = "${pkgs.atuin}/bin/atuin daemon";
            Restart = "on-failure";
            RestartSec = "15";
          };
          Unit = {
            Description = "atuin daemon";
            After = ["multi-user.target"];
            X-Restart-Triggers = [
              config.programs.atuin.package
              config.home.file."${config.home.homeDirectory}/.config/atuin/config.toml".source
            ];
          };
        };
      }
      // (lib.optionalAttrs (args ? osConfig)) {
        atuin-login = {
          Install.WantedBy = ["network-online.target"];
          Service = {
            Type = "oneshot";
            ExecStart = pkgs.writeShellScriptBin "atuin-login" ''
              if atuin status | grep -q "not logged in"; then
                atuin login --username "$(cat ${args.osConfig.sops.secrets."atuin/username".path})" \
                  --password "$(cat ${args.osConfig.sops.secrets."atuin/password".path})" \
                  --key "$(cat ${args.osConfig.sops.secrets."atuin/key".path})"
              fi
            '';
            Restart = "on-failure";
            RestartSec = "15";
          };
          Unit = {
            Description = "atuin login";
            After = ["network-online.target"];
            X-Restart-Triggers = [
              config.programs.atuin.package
              config.home.file."${config.home.homeDirectory}/.config/atuin/config.toml".source
            ];
          };
        };
      };
  };
}
