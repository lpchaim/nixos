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
    generators = let
      getBaseName = file: lib.escapeShellArg (lib.removeSuffix ".age" file);
    in {
      ssh-ed25519-keypair = {
        pkgs,
        file,
        ...
      } @ args: let
        sshKeygen = lib.getExe' pkgs.openssh "ssh-keygen";
      in ''
        priv=''$${config.age.generators.ssh-ed25519 args}
        ${sshKeygen} -yf /dev/stdin <<< "$priv" > '${getBaseName file}.pub'
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
