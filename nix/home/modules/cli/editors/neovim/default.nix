{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  cfg = config.my.cli.editors.neovim;
in {
  imports = [
    ./keymaps
    ./treesitter.nix
  ];

  options.my.cli.editors.neovim = {
    enable = lib.mkEnableOption "neovim";
    plugins.animotion.enable = lib.mkEnableOption "animotion plugin";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      imports = [./nixvimPlugins];
      opts = {
        ignorecase = true;
        smartcase = true;
      };
      nixpkgs.overlays = [self.overlays.vimPlugins];
      plugins = {
        animotion = {
          inherit (cfg.plugins.animotion) enable;
          mode = "helix";
        };
        coq = {
          enable = true;
          settings.auto_start = true;
          settings.keymap.recommended = true;
        };
        dashboard.enable = true;
        indent-blankline = {
          enable = true;
          settings = {
            exclude = {
              buftypes = [
                "terminal"
                "quickfix"
              ];
              filetypes = [
                ""
                "checkhealth"
                "dashboard"
                "help"
                "lspinfo"
                "packer"
                "TelescopePrompt"
                "TelescopeResults"
              ];
            };
          };
        };
        mini-icons.enable = true;
        mini-tabline.enable = true;
        mini-statusline.enable = true;
        mini-surround.enable = true;
        noice.enable = true;
        nvim-notify.enable = true;
        treesitter = {
          enable = true;
          folding.enable = true;
          highlight.enable = true;
          indent.enable = true;
          grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            bash
            gitattributes
            gitcommit
            gitignore
            json
            regex
            toml
            yaml
          ];
        };
        treesiter-textobjects = {
          enable = true;
          settings = {
            enable = true;
            keymaps = {
              "if" = "@function.inner";
              af = "@function.outer";
            };
            lookahead = true;
          };
        };
        telescope.enable = true;
        web-devicons.enable = true;
        which-key = {
          enable = true;
          settings = {
            preset = "helix";
          };
        };
      };
    };
  };
}
