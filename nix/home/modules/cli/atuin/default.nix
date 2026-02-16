{
  config,
  inputs,
  lib,
  osConfig ? {},
  pkgs,
  ...
}: let
  inherit (inputs.self.lib.secrets.helpers) mkSecret;
  cfg = config.my.cli.atuin;
  atuinLogin = pkgs.writeShellScriptBin "atuin-login" ''
    if atuin status | grep -q "not logged in"; then
      atuin login \
        --username '${config.home.username}' \
        --password "$(cat ${config.my.secrets."atuin-password".path})" \
        --key "$(cat ${config.my.secrets."atuin-key".path})"
    fi
  '';
in {
  options.my.cli.atuin.enable = lib.mkEnableOption "atuin";

  config = lib.mkIf cfg.enable {
    my.secrets = {
      "atuin-password" = mkSecret "atuin-password" {};
      "atuin-key" = mkSecret "atuin-key" {};
    };

    home.packages = [
      atuinLogin
    ];

    programs.mcfly.enable = lib.mkForce false;
    programs.atuin = {
      enable = true;
      daemon.enable = osConfig != {};
      daemon.logLevel = "warn";
      settings = {
        auto_sync = true;
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

    systemd.user.services.atuin-login = lib.mkIf (osConfig != {}) {
      Install.WantedBy = ["network-online.target"];
      Service = {
        Type = "oneshot";
        ExecStart = atuinLogin;
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
}
