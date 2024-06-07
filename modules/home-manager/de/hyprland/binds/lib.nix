{ lib, ... }:

with lib;
rec {
  makeDirectional = { cmd, mods ? [ ], keys ? [ "left" "right" "up" "down" ] }:
    let
      trigger = lib.concatStringsSep " " ([ "$mod" ] ++ mods);
      directions = [ "l" "r" "u" "d" ];
    in
    (genList (i: "${trigger}, ${elemAt keys i}, ${cmd}, ${elemAt directions i}") 4);
  makeDirectionalBinds = cmd: mods:
    (makeDirectional { inherit cmd mods; })
    ++ (makeDirectional { inherit cmd mods; keys = [ "H" "L" "K" "J" ]; });
  makeWorkspaceBinds = cmd: mods:
    let trigger = lib.concatStringsSep " " ([ "$mod" ] ++ mods);
    in map
      (i:
        let
          getKey = i: builtins.toString (if i == 10 then 0 else i);
          getWorkspace = i: builtins.toString (i);
        in
        "${trigger}, ${getKey i}, ${cmd}, ${getWorkspace i}")
      (lib.range 1 10);
}
