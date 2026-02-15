{
  inputs,
  config,
  lib,
  ...
}: let
  inherit (inputs.self.lib.secrets) root;
  cfg = config.my.secrets;
in {
  options.my.secrets = {
    enable = lib.mkEnableOption "secrets";
  };
  config = lib.mkIf cfg.enable {
    age = {
      rekey = {
        localStorageDir = root + /rekeyed/${config.networking.hostName};
        forceRekeyOnSystem = "x86_64-linux";
      };
    };
  };
}
