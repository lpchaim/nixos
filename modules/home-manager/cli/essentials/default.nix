{ config, lib, pkgs, ... }:

with lib;
let
  namespace = [ "my" "modules" "cli" "essentials" ];
  cfg = lib.getAttrFromPath namespace config;
in
{
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "essentials";
  };

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
      bash
      btop
      cheat
      curl
      delta
      difftastic
      du-dust
      duf
      fd
      htop
      neofetch
      ncdu
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "JetBrainsMono"
          "Overpass"
          "SourceCodePro"
        ];
      })
      nix-output-monitor
      rsync
      wget
    ];

    programs = {
      bat.enable = true;
      broot.enable = true;
      carapace.enable = true;
      dircolors.enable = true;
      direnv = {
        enable = true;
        nix-direnv.enable = true;
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
      ripgrep.enable = true;
      zoxide.enable = true;
    };
  };
}
