{
  lib,
  self,
  writeText,
  ...
}: let
  inherit (self.vars) hosts networks;
in
  hosts
  |> lib.concatMapAttrs (
    host: cfg:
      {
        "${host}" = cfg.pubKey;
        "${host}.${networks.home.domain}" = cfg.pubKey;
      }
      // lib.optionalAttrs (cfg.ip.v4 or null != null) {
        "${cfg.ip.v4}" = cfg.pubKey;
      }
  )
  |> lib.mapAttrsToList (host: key: "${host} ${key}")
  |> lib.concatStringsSep "\n"
  |> writeText "known-hosts"
