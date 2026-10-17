{
  config,
  lib,
  self,
  osConfig ? {},
  ...
}: let
  inherit (self.lib.secrets.paths) root;
  inherit (self.lib.secrets) generators helpers;
  inherit (helpers) mkSecret mkHostSecret mkUserSecret;
in {
  options.my.secret = {
    generators = lib.mkOption {
      default = generators;
      internal = true;
      readOnly = true;
    };
    helpers = let
      extraArgs = lib.optionalAttrs (osConfig != {}) {owner = config.home.username;};
    in
      lib.mkOption {
        default =
          helpers
          // {
            mkSecret = name: args:
              mkSecret name (extraArgs // args);
            mkHostSecret = configOrHost: name: args:
              mkHostSecret configOrHost name (extraArgs // args);
            mkUserSecret = configOrUser: name: args:
              mkUserSecret configOrUser name (extraArgs // args);
          };
        internal = true;
        readOnly = true;
      };
  };

  config = let
    osSecrets = osConfig.age.secrets or {};
    homeSecrets = config.my.secret.definitions;
    standaloneHomeSecrets = lib.removeAttrs homeSecrets (builtins.attrNames osSecrets);
  in
    lib.mkMerge [
      {
        my.secret.definitions = {
          "cloudflare-api-token" = mkSecret "cloudflare-api-token" {};
        };
        my.secrets = osSecrets // config.age.secrets;
        age.secrets = standaloneHomeSecrets;
      }
      (lib.mkIf (osConfig != {}) {
        age.rekey = {
          inherit (osConfig.age.rekey) hostPubkey;
          localStorageDir = root + "/.rekeyed/${osConfig.networking.hostName}-${config.home.username}";
        };
      })
      (lib.mkIf (osConfig == {}) {
        age.rekey.localStorageDir = root + "/.rekeyed/${config.my.hostName}-${config.home.username}";
      })
    ];
}
