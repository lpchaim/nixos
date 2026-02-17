{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (inputs.self.lib.secrets.paths) root;
in {
  my.secrets = config.age.secrets;
  age = {
    secrets = let
      osSecrets = config.my.secretDefinitions;
      homeConfigs = config.home-manager.users;
      homeSecrets =
        homeConfigs
        |> lib.mapAttrs (_: val: val.my.secretDefinitions)
        |> builtins.attrValues
        |> lib.mergeAttrsList;
    in
      osSecrets // homeSecrets;
    rekey = {
      localStorageDir = root + /rekeyed/${config.networking.hostName};
      forceRekeyOnSystem = "x86_64-linux";
    };
  };
}
