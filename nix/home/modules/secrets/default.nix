{
  config,
  lib,
  osConfig ? {},
  ...
}: let
  secrets = ../../../../secrets;
in {
  assertions = [
    {
      assertion = osConfig == {} -> config.age.rekey.localStorageDir != null;
      message = "Standalone home configs must explicitly set age.rekey.localStorageDir";
    }
  ];

  age.rekey = lib.mkMerge [
    (lib.mkIf (osConfig != {}) {
      inherit (osConfig.age.rekey) hostPubkey masterIdentities storageMode;
      localStorageDir = secrets + /rekeyed/${osConfig.networking.hostName}-${config.home.username};
    })
    # @TODO Implement standalone home secrets
  ];
}
