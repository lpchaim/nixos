{ lib, pkgs, ... }:

let
  inherit (lib.lpchaim.nixos) getTraitModules;
in
{
  imports =
    getTraitModules [
      "users"
      "composite/base"
    ];

  networking.hostName = "wsl";
  system.stateVersion = "24.05";

  wsl = {
    enable = true;
    docker-desktop.enable = true;
    interop = {
      includePath = true;
      register = true;
    };
    nativeSystemd = true;
    startMenuLaunchers = true;
    useWindowsDriver = true;
    wslConf = {
      automount = {
        enabled = true;
        options = "metadata,uid=1000,gid=1000";
        root = "/mnt";
      };
      interop = {
        enabled = true;
        appendWindowsPath = true;
      };
      network = {
        generateHosts = true;
        generateResolvConf = true;
      };
    };
  };

  environment.systemPackages = [
    pkgs.wget
  ];

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };
}
