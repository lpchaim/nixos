{lib, ...}: {
  imports = [
    ./nixd.nix
  ];

  options.my.development.enable = lib.mkEnableOption "development features";
}
