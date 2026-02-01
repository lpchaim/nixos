# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.self.lib.config) name shell;
  userName = name.user;
  cfg = config.my.profiles.users;
in {
  options.my.profiles.users = lib.mkEnableOption "users profile";
  config = lib.mkIf cfg {
    users = let
      defaults = {
        isNormalUser = true;
        extraGroups = ["i2c" "networkmanager" "storage" "wheel"];
      };
    in {
      mutableUsers = false;
      groups.${userName}.gid = 1000;
      groups.emily.gid = 1001;
      extraUsers = {
        ${userName} =
          defaults
          // {
            uid = 1000;
            home = "/home/${userName}";
            description = name.full;
            group = userName;
            shell = pkgs.${shell};
            hashedPasswordFile = "${config.sops.secrets."user/lpchaim/password".path}";
          };
        emily =
          defaults
          // {
            uid = 1001;
            home = "/home/emily";
            description = "emily";
            group = "emily";
            shell = pkgs.fish;
            hashedPasswordFile = "${config.sops.secrets."user/emily/password".path}";
          };
        root.hashedPassword = null;
      };
    };
    nix.settings.trusted-users = ["root" "@wheel"];
    systemd.services.ollama.serviceConfig.ReadWritePaths = [config.users.extraUsers.${userName}.home];
  };
}
