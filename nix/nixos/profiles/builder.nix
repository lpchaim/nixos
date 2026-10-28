{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (self.vars.ssh) publicKeys;
  cfg = config.my.profiles.builder;
in {
  options.my.profiles.builder = lib.mkEnableOption "builder profile";
  config = lib.mkIf cfg {
    environment.systemPackages = [pkgs.panix];
    nix.sshServe = {
      enable = true;
      write = true;
      trusted = true;
      protocol = "ssh-ng";
      keys = builtins.attrValues publicKeys.perHost;
    };
    users.users.root.openssh.authorizedKeys.keys = [publicKeys.perHost.${config.networking.hostName}];
  };
}
