{inputs, ...}: let
  inherit (inputs.self.lib.secrets) identities;
in {
  age.rekey = {
    masterIdentities = [
      (identities + /age-yubikey-identity-25388788.pub)
      (identities + /age-yubikey-identity-26583315.pub)
    ];
    storageMode = "local";
  };
}
