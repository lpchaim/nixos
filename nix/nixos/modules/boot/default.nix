{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  boot = {
    binfmt.emulatedSystems = lib.optionals pkgs.stdenv.isx86_64 ["aarch64-linux"];
    loader = {
      grub = {
        enable = mkDefault false;
        device = "nodev";
        efiSupport = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = mkDefault true;
        editor = false;
        configurationLimit = 5;
        memtest86.enable = pkgs.stdenv.isx86_64;
        netbootxyz.enable = true;
      };
    };
    initrd.systemd.enable = true;
    plymouth = {
      enable = mkDefault false;
      theme = mkDefault "breeze";
    };
    kernelParams = ["splash" "quiet" "btusb.enable_autosuspend=n"];
  };
}
