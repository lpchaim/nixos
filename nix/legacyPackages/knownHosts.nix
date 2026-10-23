{
  lib,
  self,
  writeText,
  ...
}: let
  inherit (self.vars) hosts networks;
in
  hosts
  |> lib.mapAttrsToList (
    host: cfg:
      [cfg.pubKey self.vars.ssh.publicKeys.perHost.${host}]
      |> map (
        pubKey:
          [
            "${host} ${pubKey}"
            "${host}.${networks.home.domain} ${pubKey}"
          ]
          ++ lib.optionals (cfg.ip.v4 or null != null) [
            "${cfg.ip.v4} ${pubKey}"
            "${cfg.ip.v4}.${networks.home.domain} ${pubKey}"
          ]
      )
  )
  |> lib.flatten
  |> lib.concatStringsSep "\n"
  |> writeText "known-hosts"
