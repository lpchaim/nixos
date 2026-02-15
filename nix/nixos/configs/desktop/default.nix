{inputs, ...}: let
  inherit (inputs.self.lib.config) name;
in {
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
  ];

  my = {
    ci.build = true;
    gaming.enable = true;
    networking.tailscale.trusted = true;
    profiles = {
      formfactor.desktop = true;
      hardware.gpu.nvidia = true;
      hardware.rgb = true;
      de.gnome = true;
      de.hyprland = true;
      graphical = true;
    };
  };

  networking.interfaces.enp6s0.wakeOnLan.enable = true;

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNf+oynlWr+Xq3UYKpCy8ih/w9sT6IuIKAtYjo6sfJr";
  system.stateVersion = "23.11";
  home-manager.users.${name.user}.home.stateVersion = "24.11";
}
