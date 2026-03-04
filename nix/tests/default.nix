{
  inputs,
  lib,
  self,
  ...
}: {
  imports = [
    inputs.nixtest.flakeModule
  ];

  perSystem = {
    nixtest = {
      skip = "";
      suites = {
        "Filesystems" = {
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
        "Profiles" = {
          pos = __curPos;
          tests =
            self.nixosConfigurations
            |> lib.mapAttrsToList (name: os: {
              name = "profiles-${name}";
              type = "snapshot";
              actual = let
                filterEnabled = lib.filterAttrsRecursive (_: node: node == true || (builtins.isAttrs node && node != {}));
                attrsToString = lib.mapAttrsToListRecursive (path: _: lib.concatStringsSep "." path);
              in {
                nixos = os.config.my.profiles |> filterEnabled |> attrsToString;
                home = os.config.home-manager.users.lpchaim.my.profiles |> filterEnabled |> attrsToString;
              };
            });
        };
      };
    };
  };
}
