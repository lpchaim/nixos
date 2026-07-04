{lib, ...}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "animotion";
  moduleName = "AniMotion";
  package = "animotion";

  settingsOptions = {
    mode = lib.mkOption {
      type = lib.types.enum ["animotion" "helix" "nvim"];
      default = "animotion";
      description = "See https://github.com/luiscassih/AniMotion.nvim?tab=readme-ov-file#different-modes";
    };
  };

  url = "https://github.com/luiscassih/AniMotion.nvim";
  description = "A Neovim plugin that implements selection-first text editing";
  maintainers = [lib.maintainers.lpchaim];
}
