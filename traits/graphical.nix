# Enable graphical session

{ ... }:

{
  services.xserver.enable = true;
  hardware.opengl.enable = true;
}
