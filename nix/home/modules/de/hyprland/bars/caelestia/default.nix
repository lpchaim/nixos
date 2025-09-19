{
  config,
  inputs,
  lib,
  osConfig ? {},
  ...
}: let
  inherit (inputs.self.lib) isNvidia;
  cfg = config.my.modules.de.hyprland.bars.caelestia;
in {
  options.my.modules.de.hyprland.bars.caelestia.enable = lib.mkEnableOption "Caelestia";

  config = lib.mkIf cfg.enable {
    programs.caelestia = {
      enable = true;
      systemd = {
        enable = true;
        target = "graphical-session.target";
        environment = [];
      };
      settings = {
        appearance = {
          font.family.mono = config.stylix.fonts.monospace.name;
          font.size.scale = 0.9;
          padding.scale = 0.8;
          rounding.scale = 0.8;
          spacing.scale = 0.8;
          transparency.enabled = true;
        };
        bar = {
          entries =
            builtins.map
            (id: {
              inherit id;
              enabled = true;
            })
            [
              "workspaces"
              "spacer"
              "activeWindow"
              "spacer"
              "clock"
              "tray"
              "statusIcons"
              "idleInhibitor"
              "power"
            ];
          status = {
            showAudio = true;
            showBattery = true;
            showBluetooth = true;
            showKbLayout = false;
            showMicrophone = false;
            showNetwork = true;
            showLockStatus = true;
          };
        };
        border = {
          thickness = 5;
          rounding = 10;
        };
        general.apps.terminal = ["kitty"];
        launcher.showOnHover = true;
        notifs.actionOnClick = true;
        osd.enableMicrophone = true;
        paths.wallpaperDir = "${config.xdg.userDirs.pictures}/Wallpapers";
        services = {
          audioIncrement = 0.05;
          gpuType =
            if (isNvidia osConfig)
            then "nvidia"
            else "";
          useFahrenheit = false;
          useTwelveHourClock = false;
          session.vimKeyBinds = true;
        };
      };
      cli = {
        enable = true;
        settings.theme.enableGtk = false;
      };
    };
  };
}
