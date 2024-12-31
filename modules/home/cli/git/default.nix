{
  config,
  lib,
  ...
}: let
  inherit (lib.lpchaim.shared) defaults;
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
        userEmail = defaults.email.main;
        userName = defaults.name.full;
      };
      lazygit.enable = cfg.lazygit.enable;
    };
  };
}
