{
  lib,
  self,
  ...
}: {
  perSystem = {pkgs, ...}: {
    nixtest.suites = {
      "Hyprland config is valid" = {
        pos = __curPos;
        tests =
          self.homeConfigurations
          |> lib.filterAttrs (_: {config, ...}: config.wayland.windowManager.hyprland.enable)
          |> lib.mapAttrsToList (name: {config, ...}: let
            configFileName =
              if config.wayland.windowManager.hyprland.configType == "lua"
              then "hyprland.lua"
              else "hyprland.conf";
            configFile = config.home.file."${config.home.homeDirectory}/.config/hypr/${configFileName}".source;
          in {
            name = "hyprland-${name}";
            type = "script";
            script = ''
              export XDG_RUNTIME_DIR=$(mktmp)
              ${lib.getExe pkgs.hyprland} --verify-config --config '${configFile}'
            '';
          });
      };
    };
  };
}
