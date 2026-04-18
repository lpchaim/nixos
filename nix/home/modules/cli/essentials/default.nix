{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (self.vars) shell;
  cfg = config.my.cli.essentials;
in {
  imports = [
    ./hyfetch.nix
  ];

  options.my.cli.essentials.enable = lib.mkEnableOption "essentials";

  config = lib.mkIf cfg.enable {
    home = {
      packages =
        (with pkgs; [
          _7zz # Just 7-zip
          bash
          chafa
          cheat
          curl
          delta
          difftastic
          dust
          duf
          fd
          file
          fx
          gnutar
          hexyl
          inshellisense
          jq
          ncdu
          nurl
          poppler
          procs
          progress
          resvg
          rsync
          sad
          serpl
          smartmontools
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
      ripgrep.enable = true;
      zoxide.enable = true;
    };
  };
}
