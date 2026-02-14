{
  config,
  osConfig ? {},
  ...
}: let
  secrets = ../../../../secrets;
  identities = secrets + /identities;
in {
  config.assertions = [
    {
      assertion = osConfig == {} -> config.age.rekey.localStorageDir != null;
      message = "Standalone home configs must explicitly set age.rekey.localStorageDir";
    }
  ];

  age.rekey = {
    masterIdentities = [
      (identities + /id_ed25519_sk_rk_26583315.pub)
      (identities + /id_ed25519_sk_rk_25388788.pub)
    ];
    storageMode = "local";
    localStorageDir = secrets + /rekeyed/${osConfig.networking.hostName}-${config.home.username};
  };
}
