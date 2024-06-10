{ lib, pkgs, mkShell, ... }:

with lib.lpchaim.shell;
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
