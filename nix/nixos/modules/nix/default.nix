{
  config,
  lib,
  self,
  ...
}: let
  inherit (self.vars) nix;
  inherit (self.vars.ssh) publicKeys;
  cfg = config.my.nix;
  isLix = lib.hasPrefix "lix" config.nix.package.name;
  builderConfigurations = {inherit (self.nixosConfigurations) desktop;};
in {
  options.my.nix.enable = lib.mkEnableOption "nix";
  config = lib.mkIf (cfg.enable) {
    nixpkgs = nix.pkgs;
    nix = {
      buildMachines = lib.mkIf (!isLix) (
        builderConfigurations
        |> lib.filterAttrs (name: _: config.networking.hostName != name)
        |> lib.mapAttrsToList (name: host: {
          hostName = name;
          maxJobs = 1;
          protocol = "ssh-ng";
          speedFactor = 2;
          sshUser = self.vars.name.user;
          supportedFeatures = host.config.nix.settings.system-features;
          system = host.config.nixpkgs.hostPlatform.system;
          systems = self.systems;
        })
      );
      channel.enable = lib.mkForce false;
      distributedBuilds = true;
      gc.automatic = !config.programs.nh.enable || !config.programs.nh.clean.enable;
      sshServe = lib.mkIf (builtins.hasAttr config.networking.hostName builderConfigurations) {
        enable = true;
        write = true;
        trusted = true;
        protocol = "ssh-ng";
        keys = builtins.attrValues publicKeys.perHost;
      };
    };
    lix.buildMachines.machines = lib.mkIf isLix (
      builderConfigurations
      |> lib.filterAttrs (name: _: config.networking.hostName != name)
      |> lib.mapAttrs (name: host: {
        enable = true;
        jobs = 1;
        supported-features = host.config.nix.settings.system-features;
        speed-factor = 2;
        # ssh-key = config.my.secrets.ssh.path;
        system-types = self.systems;
        uri = "ssh-ng://${self.vars.name.user}@${name}";
      })
    );
  };
}
