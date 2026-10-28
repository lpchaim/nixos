{
  lib,
  self,
  ...
}: {
  perSystem = {pkgs, ...}: {
    nixtest.suites = {
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
