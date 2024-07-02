{ pkgs, ... }:

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
  security = {
    pam.services.hyprlock = { };
    polkit.enable = true;
  };
  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      hypridle
      hyprlock
    ];
  };
  my.services.swayosd.enable = true;
}
