{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.self.lib.config) shell;
  cfg = config.my.modules.cli.essentials;
in {
  options.my.modules.cli.essentials.enable = lib.mkEnableOption "essentials";

  config = lib.mkIf cfg.enable {
    home = {
      packages =
        (with pkgs; [
          asciinema
          bash
          chafa
          cheat
          curl
          delta
          devenv
          difftastic
          du-dust
          duf
          fd
          fx
          hexyl
          htop
          inotify-tools
          inshellisense
          neofetch
          ncdu
          nh
          nix-output-monitor
          nurl
          procs
          progress
          python312Packages.howdoi
          rsync
          termshot
          tgpt
          tig
          yazi
          wget
        ])
        ++ config.stylix.fonts.packages;
      sessionVariables = {
        CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense";
        MANPAGER = "${lib.getExe pkgs.bat} --language man --plain";
        NH_FLAKE = "${config.xdg.configHome}/nixos";
      };
      shellAliases = {
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

    programs.${shell}.enable = config.programs ? "${shell}";
    programs = {
      bat.enable = true;
      broot.enable = true;
      btop.enable = true;
      carapace.enable = true;
      dircolors.enable = true;
      direnv = {
        enable = true;
        nix-direnv.enable = true;
        config.global.hide_env_diff = true;
      };
      eza = {
        enable = true;
        extraOptions = [
          "--group"
          "--group-directories-first"
        ];
        git = true;
        icons = "auto";
      };
      fzf.enable = true;
      mcfly = {
        enable = lib.mkDefault true;
        fuzzySearchFactor = 2;
        keyScheme = "vim";
      };
      nix-index.enable = true;
      nix-index-database.comma.enable = true;
      ripgrep.enable = true;
      zoxide.enable = true;
    };
  };
}
