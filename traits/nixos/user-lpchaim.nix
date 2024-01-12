# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, ... }:

{
  users = {
    # mutableUsers = false;
    # users.root.hashedPassword = "!";
    groups.lpchaim = {
      gid = 1000;
    };
    users.lpchaim = {
      isNormalUser = true;
      home = "/home/lpchaim";
      description = "Lucas Chaim";
      group = "lpchaim";
      extraGroups = [ "wheel" "networkmanager" ];
      shell = pkgs.zsh;
    };
  };
}
