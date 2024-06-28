{ lib
, pkgs
, mkShell
, ...
}:

let
  inherit (lib.lpchaim.shell) makeDevShellWithDefaults;
in
makeDevShellWithDefaults {
  inherit pkgs mkShell;
}
