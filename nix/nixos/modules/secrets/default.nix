{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (inputs.self.lib.secrets.paths) root;
in {
  age = {
    secrets = let
      osSecrets = config.my.secrets;
      homeConfigs = config.home-manager.users;
      homeSecrets =
        homeConfigs
        |> lib.mapAttrs (_: val: val.my.secrets)
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
