{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.gui.kitty;
in {
  options.my.gui.kitty.enable =
    lib.mkEnableOption "kitty"
    // {default = config.my.gui.enable;};

  config = lib.mkIf cfg.enable {
    home.sessionVariables.KITTY_LISTEN_ON = config.programs.kitty.settings.listen_on;

    programs.kitty = {
      enable = true;
      settings = {
        allow_remote_control = "socket-only";
        listen_on = "unix:/run/user/${builtins.toString config.home.uid}/kitty.sock";
      };
    };

    systemd.user = {
      services.kitty = {
        Unit = {
          Description = "Kitty";
          Requires = ["kitty.socket"];
        };
        Install = {
          Also = ["kitty.socket"];
          WantedBy = ["default.target"];
        };
        Service = {
          ExecStart = pkgs.writeShellScript "kitty-execstart" ''
            ${lib.getExe config.programs.kitty.package} \
            --single-instance \
            --start-as=hidden \
            --listen-on="${config.programs.kitty.settings.listen_on}"
          '';
          Restart = "on-failure";
        };
      };
      sockets.kitty = {
        Install = {
          WantedBy = ["sockets.target"];
        };
        Socket = {
          ListenStream = "%t/kitty.sock";
          RemoveOnStop = true;
          SocketMode = "0600";
        };
        Unit = {
          Description = "Kitty remote control socket";
        };
      };
    };
  };
}
