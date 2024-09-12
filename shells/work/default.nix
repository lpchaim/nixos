{
  lib,
  pkgs,
  mkShell,
  ...
}: let
  inherit (lib.lpchaim.shell) makeDevShellWithDefaults;
in
  makeDevShellWithDefaults {
    inherit pkgs mkShell;
    packages = with pkgs; [
      nodePackages.intelephense
      nodePackages.typescript-language-server
      phpactor
      vscode-langservers-extracted
    ];
    shellHook = ''
      nu
      $env.XDEBUG_MODE = off
    '';
  }
