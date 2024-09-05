{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
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
      packages = with pkgs; [
        bash
        cheat
        curl
        delta
        devenv
        difftastic
        du-dust
        duf
        fd
        htop
        inotify-tools
        neofetch
        ncdu
        (nerdfonts.override {fonts = myNerdFonts;})
        nix-output-monitor
        nurl
        rsync
        snowfallorg.flake
        yazi
        wget
      ];
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
        icons = true;
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
