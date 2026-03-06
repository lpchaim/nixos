{
  lib,
  self,
  ...
}: let
  activeNixosConfigurations =
    self.nixosConfigurations
    |> lib.filterAttrs (_: os: !os.config.my.deprecated);
in {
  perSystem.nixtest.suites = {
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
  };
}
