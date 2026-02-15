{
  config,
  inputs,
  lib,
  osConfig ? {},
  ...
}: let
  inherit (inputs.self.lib.secrets) root;
  cfg = config.my.secrets;
in {
  options.my.secrets = {
    enable =
      lib.mkEnableOption "secrets"
      // {default = osConfig.my.secrets.enable or false;};
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig == {} -> config.age.rekey.localStorageDir != null;
        message = "Standalone home configs must explicitly set age.rekey.localStorageDir";
      }
    ];

    age.rekey = lib.mkIf (osConfig != {}) {
      inherit (osConfig.age.rekey) hostPubkey;
      localStorageDir = root + "/rekeyed/${osConfig.networking.hostName}-${config.home.username}";
    };
  };
}
