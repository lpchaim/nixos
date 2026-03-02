{
  config,
  lib,
  ...
}: {
  imports = [
    ./helix.nix
  ];

  config = lib.mkIf config.my.cli.editors.neovim.enable {
    programs.nixvim = {
      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };
      keymaps = lib.mapAttrsToList (key: attrs: attrs // {inherit key;}) {
        "Y" = {
          mode = "n";
          action = "yg_";
          options.desc = "Copy remainder of line";
          options.remap = true;
        };
      };
    };
  };
}
