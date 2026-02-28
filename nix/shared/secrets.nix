{
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

  config.age.rekey = {
    masterIdentities = [
      identities.primaryYubikey
      identities.secondaryYubikey
    ];
    storageMode = "local";
  };
}
