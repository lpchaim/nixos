{
  config,
  inputs,
  lib,
  osConfig ? {},
  ...
}: let
  inherit (inputs.self.lib.secrets) root forUser;
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

    age.rekey = lib.mkMerge [
      (lib.mkIf (osConfig != {}) {
        inherit (osConfig.age.rekey) hostPubkey masterIdentities storageMode;
        localStorageDir = root + "/rekeyed/${config.home.username}@${osConfig.networking.hostName}";
      })
      # @TODO Implement standalone home secrets
    ];
  };
}
