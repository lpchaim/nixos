{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  inherit (lib.lpchaim.shared) defaults;
  namespace = ["my" "modules" "cli" "essentials"];
  cfg = lib.getAttrFromPath namespace config;
in {
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "essentials";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages =
        (with pkgs; [
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
          neofetch
          ncdu
          nh
          nix-output-monitor
          nurl
          procs
          progress
          python312Packages.howdoi
          rsync
          snowfallorg.flake
          tgpt
          tig
          yazi
          wget
        ])
        ++ config.stylix.fonts.packages;
      sessionVariables = {
        NH_FLAKE = "${config.xdg.configHome}/nixos";
      };
      shellAliases = {
        gco = "git checkout";
        gd = "git diff";
        gds = "git diff --staged";
        gl = "git log";
        glg = "git log --graph";
        gst = "git status";
      };
    };

    programs.${defaults.shell}.enable = config.programs ? "${defaults.shell}";
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
        enable = mkDefault true;
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
