{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (inputs.self.lib.secrets) identities;
in {
  options.my = {
    secret.definitions = lib.mkOption {
      description = "Secret definitions";
      default = [];
    };
    secrets = lib.mkOption {
      description = "Rendered secrets";
      default = [];
    };
  };

  config.age = {
    generators = {
      ssh-ed25519-keypair = {
        pkgs,
        name,
        file,
        ...
      } @ args: let
        sshKeygen = lib.getExe' pkgs.openssh "ssh-keygen";
        baseName = lib.escapeShellArg (lib.removeSuffix ".age" file);
      in ''
        priv=''$${config.age.generators.ssh-ed25519 args}
        ${sshKeygen} -yf /dev/stdin <<< "$priv" > '${baseName}.pub'
        echo "$priv"
      '';
    };
    rekey = {
      masterIdentities = [
        identities.primaryYubikey
        identities.secondaryYubikey
      ];
      storageMode = "local";
    };
  };
}
