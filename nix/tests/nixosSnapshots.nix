{
  lib,
  self,
  ...
}: {
  perSystem.nixtest.suites = {
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
    "Generated IDs are stable" = {
      pos = __curPos;
      tests =
        [0 1 (-1) "desktop"]
        |> lib.imap (i: seed: {
          name = "generated-id-${toString seed}";
          type = "snapshot";
          actual = self.lib.mkStableNumericId null seed;
        });
    };
    "Generated UUIDs are stable" = {
      pos = __curPos;
      tests =
        [0 1 (-1) "desktop"]
        |> lib.imap (i: seed: {
          name = "generated-uuid-${toString seed}";
          type = "snapshot";
          actual = self.lib.mkStableUuid seed;
        });
    };
  };
}
