{
  config,
  self,
  lib,
  pkgs,
  ...
}: let
  inherit (self.lib.secrets.paths) root;
  inherit (self.lib.secrets) generators helpers;
in {
  options.my.secret = {
    generators = lib.mkOption {
      default = generators;
      internal = true;
      readOnly = true;
    };
    helpers = lib.mkOption {
      default = helpers;
      internal = true;
      readOnly = true;
    };
  };

  config = {
    my.secrets = config.age.secrets;
    age = {
      ageBin = lib.getExe pkgs.rage;
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
