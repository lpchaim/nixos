{
  config,
  lib,
  self,
  ...
}: let
  inherit (self.vars) email name;
  cfg = config.my.cli.git;
in {
  options.my.cli.git = {
    enable = lib.mkEnableOption "git";
    aliases.enable = lib.mkEnableOption "git aliases";
    delta.enable = lib.mkEnableOption "delta diffs for git";
    difftastic.enable = lib.mkEnableOption "difftastic diffs for git";
    lazygit.enable = lib.mkEnableOption "lazygit";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      delta = {
        enable = cfg.delta.enable;
        enableGitIntegration = true;
      };
      difftastic = {
        enable = cfg.difftastic.enable;
        options = {
          color = "always";
          sort-paths = true;
          skip-unchanged = true;
          tab-width = 2;
        };
        git = {
          enable = true;
          mode = "both";
        };
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
        signing.format = "openpgp";
      };
      lazygit = lib.mkIf cfg.lazygit.enable {
        enable = true;
        settings = {
          git.diffRenderers =
            lib.optionals cfg.delta.enable [
              {
                name = "delta";
                type = "stdinFilter";
                command = "delta --paging=never --color-only";
              }
            ]
            ++ lib.optionals cfg.difftastic.enable [
              {
                name = "difftastic";
                type = "extDiff";
                command = "difft --color=always --background={{colorScheme}} --context={{diffContext}}";
              }
            ]
            ++ [
              {
                name = "git";
                type = "rawGit";
                args = ["--no-ext-diff"];
              }
            ];
          gui.tabWidth = 2;
          update.method = "never";
        };
      };
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
