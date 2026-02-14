{
  config,
  lib,
  ...
}: let
  cfg = config.my.profiles.de;
in {
  assertions =
    cfg
    |> lib.filterAttrs (_: enabled: enabled)
    |> lib.mapAttrsToList (name: _: {
      assertion = config.hardware.graphics.enable;
      message = "config.my.profiles.de.${name} is useless without graphics";
    });

  imports = [
    ./gnome.nix
    ./hyprland.nix
    ./plasma.nix
  ];
}
