{ lib, pkgs, ... }:

let
  inherit (lib.lpchaim.shell) makeDevShellWithDefaultPackages;
in
makeDevShellWithDefaultPackages {
  inherit pkgs;
  packages = with pkgs; [
    nodePackages.intelephense
    nodePackages.typescript-language-server
    phpactor
    vscode-langservers-extracted
  ];
  shellHook = ''
    zsh
  '';
}
