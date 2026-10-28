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
          chafa
          curl
          delta
          dust
          duf
          fd
          file
          gnutar
          hexyl
          jq
          ncdu
          netcat
          procs
          progress
          resvg
          rsync
          smartmontools
          tig
          wget
          zip
        ])
        ++ config.stylix.fonts.packages;
      sessionVariables = {
        MANPAGER = "${lib.getExe pkgs.bat} --language man --plain";
      };
    };

    programs = {
      ${shell}.enable = true;
      bash.enable = true;
      bat.enable = true;
      broot.enable = true;
      btop.enable = true;
      carapace = {
        enable = true;
        extraPackages = with pkgs; [
          config.programs.zsh.package
          config.programs.fish.package
          inshellisense
          config.programs.bash.package
        ];
        environment = {
          CARAPACE_BRIDGES =
            config.programs.carapace.extraPackages
            |> map (pkg: pkg.meta.mainProgram or pkg.pname)
            |> lib.concatStringsSep ",";
          CARAPACE_LENIENT = 1;
          CARAPACE_MATCH = 1; # Case insensitive
          CARAPACE_MERGEFLAGS = 1;
        };
      };
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
