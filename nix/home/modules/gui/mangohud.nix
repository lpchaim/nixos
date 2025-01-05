{
  config,
  lib,
  osConfig ? {},
  ...
}: let
  cfg = config.my.modules.gui.mangohud;
in {
  options.my.modules.gui.mangohud.enable =
    lib.mkEnableOption "gui apps"
    // {
      default =
        config.my.modules.gui.enable
        && (
          (osConfig == {})
          || !(osConfig ? jovian)
          || !osConfig.jovian.steam.enable
        );
    };

  config = lib.mkIf cfg.enable {
    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
      settings = {
        fps_limit = "0,142";
        fps_limit_method = "late";
        preset = "0,1,2,3,4";
        alpha = 1;
        background_alpha = 0.3;
        round_corners = 10.0;
      };
    };
    home.file.".config/MangoHud/presets.conf".text = ''
      [preset 0]
      no_display

      [preset 1]
      control=mangohud
      show_fps_limit
      background_alpha = 0
      frame_timing=0
      cpu_stats=0
      gpu_stats=0
      fps=1
      fps_only
      legacy_layout=0
      width=40
      frametime=0

      [preset 2]
      control=mangohud
      show_fps_limit
      background_alpha = 0
      legacy_layout=0
      horizontal
      battery
      gpu_stats
      cpu_stats
      cpu_power
      gpu_power
      ram
      fps
      frametime=0
      hud_no_margin
      table_columns=14
      frame_timing=1

      [preset 3]
      control=mangohud
      show_fps_limit
      cpu_temp
      gpu_temp
      ram
      vram
      io_read
      io_write
      arch
      gpu_name
      cpu_power
      gpu_power
      wine
      frametime
      battery

      [preset 4]
      show_fps_limit
      control=mangohud
      full
      cpu_temp
      gpu_temp
      ram
      vram
      io_read
      io_write
      arch
      gpu_name
      cpu_power
      gpu_power
      wine
      frametime
      battery
    '';
  };
}
