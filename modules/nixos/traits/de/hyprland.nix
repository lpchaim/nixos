{pkgs, ...}:
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
    pam.services.hyprlock = {};
    polkit.enable = true;
  };
  xdg.portal = {
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };
  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      hypridle
      hyprlock
    ];
  };
}
