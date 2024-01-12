{ config, lib, pkgs, ... }:

with lib;
let
  namespace = [ "my" "modules" "de" "gnome" "extensions" "dash-to-panel" ];
  cfg = getAttrFromPath namespace config;
in
{
  options = setAttrByPath namespace {
    enable = mkEnableOption "Dash to Panel.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs.gnomeExtensions; [
      dash-to-panel
    ];
    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          "dash-to-dock@micxgx.gmail.com"
        ];
      };
      "org/gnome/shell/extensions/dash-to-panel" = {
        panel-lengths = builtins.toJSON { "0" = 100; };
        panel-anchors = builtins.toJSON { "0" = "MIDDLE"; };
        panel-positions = builtins.toJSON { "0" = "TOP"; };
        panel-sizes = builtins.toJSON { "0" = 48; };
        panel-element-positions = builtins.toJSON {
          "0" = [
            { element = "showAppsButton"; position = "stackedTL"; visible = true; }
            { element = "activitiesButton"; position = "stackedTL"; visible = false; }
            { element = "leftBox"; position = "stackedTL"; visible = true; }
            { element = "taskbar"; position = "stackedTL"; visible = true; }
            { element = "centerBox"; position = "centered"; visible = true; }
            { element = "dateMenu"; position = "centerMonitor"; visible = true; }
            { element = "rightBox"; position = "stackedBR"; visible = true; }
            { element = "systemMenu"; position = "stackedBR"; visible = true; }
            { element = "desktopButton"; position = "stackedBR"; visible = true; }
          ];
        };
        trans-panel-opacity = 0.60;

        show-apps-icon-side-padding = 0;
        appicon-margin = 4;
        appicon-padding = 6;
        focus-highlight-dominant = true;
        focus-highlight-opacity = 10;
        dot-color-dominant = true;
        dot-position = "TOP";
        dot-style-focused = "DASHES";
        dot-style-unfocused = "DASHES";

        show-desktop-hover = true;
        show-desktop-delay = 500;
        window-preview-title-position = "TOP";
        hotkeys-overlay-combo = "TEMPORARILY";

        isolate-workspaces = true;
        hide-overview-on-startup = true;
      };
    };
  };
}
