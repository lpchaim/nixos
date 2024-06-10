# Use the Hyprland compositor

{
  imports = [
    ../pipewire.nix
    ../wayland.nix
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  security.polkit.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
