{ lib, pkgs, ... }:

with lib.lpchaim.shell;
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
