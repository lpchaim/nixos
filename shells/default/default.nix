{ lib, pkgs, mkShell, ... }:

let
  inherit (lib.lpchaim.shell) makeDevShellWithDefaultPackages;
in
makeDevShellWithDefaultPackages {
  inherit pkgs mkShell;
  packages = with pkgs; [
    age
    pre-commit
    ssh-to-age
    sops
  ];
  shellHook = ''
    pre-commit install
  '';
}
