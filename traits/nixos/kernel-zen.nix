# Use the Zen kernel

{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_zen;

}
