{
  config,
  lib,
  self,
  ...
}: let
  inherit (self.vars) nix;
  cfg = config.my.nix;
  isLix = lib.hasPrefix "lix" config.nix.package.name;
  builderConfigurations =
    self.nixosConfigurations
    |> lib.filterAttrs (name: host: config.networking.hostName != name && host.config.my.profiles.builder);
in {
  options.my.nix.enable = lib.mkEnableOption "nix";
  config = lib.mkIf (cfg.enable) {
    nixpkgs = nix.pkgs;
    nix = {
      buildMachines = lib.mkIf (!isLix) (
        builderConfigurations
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
      channel.enable = lib.mkDefault true;
      distributedBuilds = true;
      gc.automatic = !config.programs.nh.enable || !config.programs.nh.clean.enable;
    };
    lix.buildMachines.machines = lib.mkIf isLix (
      builderConfigurations
      |> lib.mapAttrs (name: host: {
        enable = true;
        jobs = 1;
        supported-features = host.config.nix.settings.system-features;
        speed-factor = 2;
        system-types = self.systems;
        uri = "ssh-ng://${self.vars.name.user}@${name}";
      })
    );
  };
}
