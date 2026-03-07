{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.cli.essentials.hyfetch;
in {
  options.my.cli.essentials.hyfetch = {
    enable =
      lib.mkEnableOption "hyfetch"
      // {default = config.my.cli.essentials.enable;};
    backend = lib.mkOption {
      type = lib.types.enum ["fastfetch" "macchina"];
      default = "fastfetch";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      fastfetch
      macchina
    ];
    programs.hyfetch = {
      enable = true;
      settings = {
        inherit (cfg) backend;
        args =
          (
            if (cfg.backend == "fastfetch")
            then [
              "--detect-version false"
              "--structure '${lib.concatStringsSep ":" [
                "OS"
                "Kernel"
                "Packages"
                "WM"
                "Shell"
                "Editor"
                "Icons"
                "Font"
                "Cursor"
                "Terminal"
                "TerminalFont"
                "Cpu"
                "Gpu"
                "Memory"
                "Display"
                "Colors"
              ]}'"
            ]
            else [
              "--show '${lib.concatStringsSep "," [
                "host"
                "kernel"
                "distribution"
                "desktop-environment"
                "packages"
                "shell"
                "terminal"
                "resolution"
                "processor"
                "memory"
                "gpu"
              ]}'"
            ]
          )
          |> lib.concatStringsSep " ";
        auto-detect-light-dark = true;
        color_align = {
          mode = "custom";
          custom_colors = {
            "1" = 3;
            "2" = 2;
            "3" = 4;
            "4" = 2;
            "5" = 1;
            "6" = 2;
          };
          fore_back = [];
        };
        distro = "nixos_colorful";
        mode = "rgb";
        preset = "transbian";
        pride_month_disable = false;
        pride_month_shown = [];
      };
    };
  };
}
