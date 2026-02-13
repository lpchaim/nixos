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
    aliases.enable = lib.mkEnableOption "git aliases" // {default = cfg.enable;};
    delta.enable = lib.mkEnableOption "delta diffs for git" // {default = cfg.enable;};
    lazygit.enable = lib.mkEnableOption "lazygit" // {default = cfg.enable;};
  };

  config = lib.mkIf cfg.enable {
    programs = {
      delta = lib.mkIf cfg.delta.enable {
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

    home.shellAliases = lib.mkIf cfg.aliases.enable {
      gco = "git checkout";
      gd = "git diff";
      gds = "git diff --staged";
      gl = "git log";
      glg = "git log --graph";
      gp = "git pull";
      gs = "git switch";
      gsc = "git switch --create";
      gst = "git status";
    };
  };
}
