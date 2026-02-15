{
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs.self.lib.config) name;
in {
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
  ];

  my = {
    ci.build = true;
    security.u2f.relaxed = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  nixpkgs.hostPlatform = "aarch64-linux";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILr9pl4qaL/+DV//lhE5y6V7xJ2eh1BSlwNYD9L9a2sQ";
  system.stateVersion = "24.05";
  home-manager.users.${name.user}.home.stateVersion = "24.05";
}
