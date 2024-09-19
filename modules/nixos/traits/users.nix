# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.lpchaim.shared) defaults;
  userName = defaults.name.user;
in {
  users = {
    mutableUsers = false;
    groups.${userName} = {
      gid = 1000;
    };
    extraUsers = {
      ${userName} = {
        uid = 1000;
        home = "/home/${userName}";
        description = defaults.name.full;
        isNormalUser = true;
        group = userName;
        extraGroups = ["i2c" "networkmanager" "storage" "wheel"];
        shell = pkgs.${defaults.shell};
        hashedPasswordFile = "${config.sops.secrets."password".path}";
      };
      root.hashedPassword = null;
    };
  };
  nix.settings.trusted-users = ["root" "@wheel"];
  systemd.services.ollama.serviceConfig.ReadWritePaths = [config.users.extraUsers.${userName}.home];
}
