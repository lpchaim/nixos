{
  config,
  inputs,
  lib,
  osConfig ? {},
  ...
}: let
  inherit (inputs.self.lib.secrets.paths) root;
in {
  config = let
    osSecrets = osConfig.age.secrets or {};
    homeSecrets = config.my.secretDefinitions;
    standaloneHomeSecrets = lib.removeAttrs homeSecrets (builtins.attrNames osSecrets);
  in {
    my.secrets = osSecrets // config.age.secrets;
    age = {
      secrets = standaloneHomeSecrets;
      rekey = lib.mkIf (osConfig != {}) {
        inherit (osConfig.age.rekey) hostPubkey;
        localStorageDir = root + "/rekeyed/${osConfig.networking.hostName}-${config.home.username}";
      };
    };
  };
}
