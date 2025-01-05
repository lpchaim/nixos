{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (inputs.self.lib.config) email name;
  cfg = config.my.modules.cli.git;
in {
  options.my.modules.cli.git = {
    enable = lib.mkEnableOption "git";
    lazygit.enable = lib.mkEnableOption "lazygit" // {default = cfg.enable;};
  };

  config = lib.mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        delta.enable = true;
        extraConfig = {
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
          pull.rebase = false;
        };
        userEmail = email.main;
        userName = name.full;
      };
      lazygit.enable = cfg.lazygit.enable;
    };
  };
}
