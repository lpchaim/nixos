{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (inputs.self.lib.config) email name;
  cfg = config.my.cli.git;
in {
  options.my.cli.git = {
    enable = lib.mkEnableOption "git";
    lazygit.enable = lib.mkEnableOption "lazygit" // {default = cfg.enable;};
  };

  config = lib.mkIf cfg.enable {
    programs = {
      delta = {
        enable = true;
        enableGitIntegration = true;
      };
      git = {
        enable = true;
        settings = {
          init.defaultBranch = "main";
          pull.rebase = true;
          push.autoSetupRemote = true;
          rebase.autoStash = true;
          user.email = email.main;
          user.name = name.full;
        };
      };
      lazygit.enable = cfg.lazygit.enable;
    };
  };
}
