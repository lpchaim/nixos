{self, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
    (self + /nix/shared/storage/zfsPool.nix)
  ];

  my = {
    gaming = {
      enable = true;
      freesmlauncher.enable = true;
      osu.enable = true;
    };
    networking = {
      tailscale = {
        enable = true;
        advertise.exitNode = true;
        advertise.routes = [self.vars.networks.home.routingPrefix];
      };
      trusted = true;
    };
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
      builder = true;
      graphical = true;
    };
  };

  system.stateVersion = "23.11";
}
