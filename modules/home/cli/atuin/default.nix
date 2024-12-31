{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}: let
  cfg = config.my.modules.cli.atuin;
in {
  options.my.modules.cli.atuin.enable =
    lib.mkEnableOption "atuin"
    // {default = config.my.modules.cli.enable;};
  config = lib.mkIf cfg.enable {
    programs.mcfly.enable = lib.mkForce false;
    programs.atuin = {
      enable = true;
      settings = {
        auto_sync = true;
        daemon.enabled = true;
        dialect = "uk";
        inline_height = 25;
        keymap_mode = "vim-insert";
        keymap_cursor.vim_insert = "steady-bar";
        keymap_cursor.vim_normal = "steady-block";
        history_format = "{time}  {host}  {directory}  {command}";
        filter_mode = "global";
        search_mode = "fuzzy";
        filter_mode_shell_up_key_binding = "host";
        search_mode_shell_up_key_binding = "prefix";
        store_failed = false;
        sync_frequency = "15m";
        workspaces = true;
      };
    };
    systemd.user.services =
      {
        atuin-daemon = {
          Install.WantedBy = ["default.target"];
          Service = {
            ExecStart = "${pkgs.atuin}/bin/atuin daemon";
            Restart = "on-failure";
            RestartSec = "15";
          };
          Unit = {
            Description = "atuin daemon";
            After = ["default.target"];
            X-Restart-Triggers = [
              config.programs.atuin.package
              config.home.file."${config.home.homeDirectory}/.config/atuin/config.toml".source
            ];
          };
        };
      }
      // (lib.optionalAttrs (osConfig != null)) {
        atuin-login = {
          Install.WantedBy = ["network-online.target"];
          Service = {
            Type = "oneshot";
            ExecStart = let
              inherit (osConfig.sops) secrets;
            in
              pkgs.writeShellScriptBin "atuin-login" ''
                if atuin status | grep -q "not logged in"; then
                  atuin login \
                    --username "$(cat ${secrets."atuin/username".path})" \
                    --password "$(cat ${secrets."atuin/password".path})" \
                    --key "$(cat ${secrets."atuin/key".path})"
                fi
              '';
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
