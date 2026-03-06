{
  config,
  self,
  lib,
  ...
}: let
  inherit (self.lib.secrets.paths) root;
  inherit (self.lib.secrets) helpers;
in {
  options.my.secret.helpers = lib.mkOption {
    default = helpers;
  };

  config = {
    my.secrets = config.age.secrets;
    age = {
      secrets = let
        osSecrets = config.my.secret.definitions;
        homeConfigs = config.home-manager.users;
        homeSecrets =
          homeConfigs
          |> lib.mapAttrs (_: val: val.my.secret.definitions)
          |> builtins.attrValues
          |> lib.mergeAttrsList;
      in
        osSecrets // homeSecrets;
      rekey = {
        hostPubkey = lib.mkIf (config.my.hostVars ? pubKey) config.my.hostVars.pubKey;
        localStorageDir = root + /.rekeyed/${config.networking.hostName};
        forceRekeyOnSystem = "x86_64-linux";
      };
    };
  };
}
