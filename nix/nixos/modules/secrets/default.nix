{
  inputs,
  config,
  lib,
  ...
}: let
  inherit (inputs.self.lib.secrets) root identities mkSecret mkHostSecret mkUserSecret;
  cfg = config.my.secrets;
  mkHostSecret' = mkHostSecret config.networking.hostName;
in {
  imports = [
    ./atuin.nix
    ./extraNixOptions.nix
  ];

  options.my.secrets = {
    enable = lib.mkEnableOption "secrets";
  };
  config = lib.mkIf cfg.enable {
    age = {
      rekey = {
        masterIdentities = [
          (identities + /age-yubikey-identity-25388788.pub)
          (identities + /age-yubikey-identity-26583315.pub)
        ];
        localStorageDir = root + /rekeyed/${config.networking.hostName};
        storageMode = "local";
        forceRekeyOnSystem = "x86_64-linux";
      };
      secrets = {
        "atuin-password" = mkSecret "atuin-password" {};
        "atuin-key" = mkSecret "atuin-key" {};
        "nix-extra-access-tokens" = mkSecret "nix-extra-access-tokens" {
          mode = "0400";
          # owner = name.user;
        };
        "tailscale-oauth-secret" = mkSecret "tailscale-oauth-secret" {};
        "u2f-mappings" = mkSecret "u2f-mappings" {
          group = "wheel";
          mode = "0440";
        };
        "host.syncthing-cert" = mkHostSecret' "syncthing-cert" {
          mode = "0440";
        };
        "host.syncthing-key" = mkHostSecret' "syncthing-key" {
          mode = "0440";
        };
        "user.emily.password" = mkUserSecret "emily" "password" {};
        "user.lpchaim.password" = mkUserSecret "lpchaim" "password" {};
      };
    };
  };
}
