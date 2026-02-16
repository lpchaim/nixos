{
  inputs,
  lib,
  options,
  ...
}: let
  inherit (inputs.self.lib.secrets.paths) identities;
in {
  options.my.secrets = lib.mkOption {
    inherit (options.age.secrets) default description type;
  };

  config.age.rekey = {
    masterIdentities = [
      (identities + /age-yubikey-identity-25388788.pub)
      (identities + /age-yubikey-identity-26583315.pub)
    ];
    storageMode = "local";
  };
}
