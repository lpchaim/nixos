{
  lib,
  self,
  ...
}: let
  activeNixosConfigurations =
    self.nixosConfigurations
    |> lib.filterAttrs (_: os: !os.config.my.deprecated);
in {
  perSystem = {pkgs, ...}: {
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
      "Systemd escaping matches binary logic" = {
        pos = __curPos;
        tests =
          ["/dev/ttyACM0" "/dev/serial/by-id/usb-NXP_SEMICONDUCTORS_MCU_VIRTUAL_COM_DEMO-if00"]
          |> lib.imap (i: path: rec {
            name = "systemd-path-${actual}";
            actual = self.lib.systemd.escapePath path |> lib.trim;
            expected =
              pkgs.runCommandLocal "escaped-expected-${toString i}" {buildInputs = [pkgs.systemd];} ''
                systemd-escape --path '${path}' > $out
              ''
              |> builtins.readFile
              |> lib.trim;
          });
      };
    };
  };
}
