{config, ...}: let
  inherit (config.my.config) name;
in {
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
  ];

  my = {
    ci.build = true;
    gaming.steam.enable = true;
    networking.tailscale.trusted = true;
    profiles = {
      formfactor.laptop = true;
      hardware.cpu.intel = true;
      de.gnome = true;
      de.hyprland = true;
      graphical = true;
    };
  };

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHh5IZnZipti8mCt0NPCVrJ5XTU2z+nb7d2hgMG4/B3C";
  system.stateVersion = "23.11";
  home-manager.users.${name.user}.home.stateVersion = "23.05";
}
