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
          netcat
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
      fzf = {
        enable = true;
        historyWidget.command = "";
      };
      ripgrep.enable = true;
      yazi = {
        enable = true;
        shellWrapperName = "y";
        initLua =
          # lua
          ''
            Status:children_add(function()
            	local h = cx.active.current.hovered
            	if not h or ya.target_family() ~= "unix" then
            		return ""
            	end

            	return ui.Line {
            		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)),
            		":",
            		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)),
            		" ",
            	}
            end, 500, Status.RIGHT)
          '';
      };
      zoxide.enable = true;
    };
  };
}
