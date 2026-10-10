{
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
  ];

  my = {
    ci.build = true;
    gaming = {
      enable = true;
      freesmlauncher.enable = true;
      osu.enable = true;
    };
    networking.trusted = true;
    serving.enable = true;
    virtualization.enable = true;
    users.emily.enable = true;
    profiles = {
      formfactor.desktop = true;
      hardware.gpu.nvidia = true;
      hardware.rgb = true;
      de.gnome = true;
      de.hyprland = true;
      greeter.gdm = true;
      graphical = true;
    };
  };

  system.stateVersion = "23.11";
}
