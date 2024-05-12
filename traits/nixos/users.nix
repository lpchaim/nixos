# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

let
  userName = "lpchaim";
  fullName = "Lucas Chaim";
in
{
  users = {
    mutableUsers = false;
    groups.${userName} = {
      gid = 1000;
    };
    users = {
      ${userName} = {
        isNormalUser = true;
        home = "/home/${userName}";
        description = fullName;
        group = userName;
        extraGroups = [ "wheel" "networkmanager" ];
        shell = pkgs.zsh;
        hashedPasswordFile = "${config.sops.secrets."password".path}";
      };
      root.hashedPassword = null;
    };
  };
}
