{self, ...}: let
  inherit (self.vars) name;
in {
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
  ];

  my = {
    ci.build = true;
    gaming.steam.enable = true;
    networking.trusted = true;
    virtualization.oci.enable = true;
    profiles = {
      formfactor.laptop = true;
      hardware.cpu.intel = true;
      de.hyprland = true;
      greeter.gdm = true;
      graphical = true;
    };
  };

  system.stateVersion = "23.11";
  home-manager.users.${name.user}.home.stateVersion = "23.05";
}
