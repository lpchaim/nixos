{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.my.config) flake shell;
  cfg = config.my.cli.essentials;
in {
  options.my.cli.essentials.enable = lib.mkEnableOption "essentials";

  config = lib.mkIf cfg.enable {
    home = {
      packages =
        (with pkgs; [
          _7zz # Just 7-zip
          asciinema
          bash
          chafa
          cheat
          curl
          delta
          devenv
          difftastic
          dust
          duf
          fd
          ffmpeg
          file
          fx
          gnutar
          hexyl
          htop
          imagemagick
          inotify-tools
          inshellisense
          jq
          neofetch
          ncdu
          nix-output-monitor
          nurl
          poppler
          procs
          progress
          python312Packages.howdoi
          resvg
          rsync
          sad
          serpl
          termshot
          tgpt
          tig
          yazi
          wget
          zip
        ])
        ++ config.stylix.fonts.packages;
      sessionVariables = {
        CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense";
        MANPAGER = "${lib.getExe pkgs.bat} --language man --plain";
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
      nh = {
        enable = lib.mkDefault true;
        flake = builtins.replaceStrings ["~"] [config.home.homeDirectory] flake.path;
      };
      nix-index.enable = true;
      nix-index-database.comma.enable = true;
      ripgrep.enable = true;
      zoxide.enable = true;
    };
  };
}
