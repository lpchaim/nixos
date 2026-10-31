{
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
  ];

  my = {
    gaming.steam.enable = true;
    networking.trusted = true;
    profiles = {
      formfactor.laptop = true;
      hardware.cpu.intel = true;
      de.gnome = true;
      de.hyprland = true;
      greeter.gdm = true;
      graphical = true;
    };
  };

  system.stateVersion = "23.11";
}
