{
  config,
  inputs,
  lib,
  osConfig ? {},
  ...
}: let
  inherit (inputs.self.lib.secrets.paths) root;
in {
  assertions = [
    {
      assertion = osConfig == {} -> config.age.rekey.localStorageDir != null;
      message = "Standalone home configs must explicitly set age.rekey.localStorageDir";
    }
  ];

  age = {
    secrets = let
      osSecrets = osConfig.age.secrets or {};
      homeSecrets = config.my.secrets;
      standaloneHomeSecrets = lib.removeAttrs homeSecrets (builtins.attrNames osSecrets);
    in
      standaloneHomeSecrets;
    rekey = lib.mkIf (osConfig != {}) {
      inherit (osConfig.age.rekey) hostPubkey;
      localStorageDir = root + "/rekeyed/${osConfig.networking.hostName}-${config.home.username}";
    };
  };
}
