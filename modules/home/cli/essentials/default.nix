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
  myNerdFonts = ["FiraCode" "JetBrainsMono" "Overpass" "SourceCodePro"];
in {
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "essentials";
  };

  config = lib.mkIf cfg.enable {
    fonts.fontconfig = {
      enable = true;
      defaultFonts.monospace = [config.stylix.fonts.monospace.name] ++ myNerdFonts;
    };

    home = {
      packages = with pkgs;
        [
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
          (nerdfonts.override {fonts = myNerdFonts;})
          nh
          nix-output-monitor
          nurl
          procs
          rsync
          snowfallorg.flake
          tgpt
          tig
          yazi
          wget
          python312Packages.howdoi
        ]
        ++ (lib.optionals (pkgs.stdenv.isx86_64) [
          omnix-cli
        ]);
      sessionVariables = {
        FLAKE = "${config.xdg.configHome}/nixos";
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
