{
  lib,
  self,
  ...
}: let
  activeNixosConfigurations =
    self.nixosConfigurations
    |> lib.filterAttrs (_: os: !os.config.my.deprecated);
in {
  perSystem = _: {
    nixtest.suites = {
      "Active hosts have vars" = {
        pos = __curPos;
        tests =
          activeNixosConfigurations
          |> lib.mapAttrsToList (name: os: {
            name = "vars-${name}";
            actual = os.config.my.hostVars != {};
            expected = true;
          });
      };
      "Active servers have an IPv4 address" = {
        pos = __curPos;
        tests =
          activeNixosConfigurations
          |> lib.filterAttrs (_: os: os.config.my.profiles.server)
          |> lib.mapAttrsToList (name: os: {
            name = "ipv4-${name}";
            actual = os.config.my.hostVars.ip.v4 or null != null;
            expected = true;
          });
      };
      "Active servers have authorized keys" = {
        pos = __curPos;
        tests =
          activeNixosConfigurations
          |> lib.filterAttrs (_: os: os.config.my.profiles.server)
          |> lib.mapAttrsToList (name: os: {
            name = "authorizedkeys-${name}";
            actual = let
              inherit (os.config.users.users.lpchaim.openssh.authorizedKeys) keys keyFiles;
            in
              (builtins.length (keys ++ keyFiles)) > 0;
            expected = true;
          });
      };
      "Age pubkeys are stable" = {
        pos = __curPos;
        tests =
          self.nixosConfigurations
          |> lib.mapAttrsToList (name: os: {
            name = "pubkey-${name}";
            type = "snapshot";
            actual = os.config.age.rekey.hostPubkey;
          });
      };
      "Filesystems are stable" = {
        pos = __curPos;
        tests =
          self.nixosConfigurations
          |> lib.mapAttrsToList (name: os: {
            name = "filesystems-${name}";
            type = "snapshot";
            actual =
              os.config.fileSystems
              |> lib.filterAttrs (_: cfg: cfg.enable)
              |> lib.mapAttrs (_: cfg: {inherit (cfg) device fsType options;});
          });
      };
    };
  };
}
