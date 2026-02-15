{
  config,
  lib,
  ...
}: {
  imports = [
    ./atuin.nix
    ./extraNixOptions.nix
  ];

  age = let
    secrets = ../../../../secrets;
    identities = secrets + /identities;
    perHost = secrets + /perHost/${config.networking.hostName};
    perUser = user: secrets + /perUser/${user};
  in {
    rekey = {
      masterIdentities = [
        (identities + /age-yubikey-identity-25388788.pub)
        (identities + /age-yubikey-identity-26583315.pub)
      ];
      localStorageDir = secrets + /rekeyed/${config.networking.hostName};
      storageMode = "local";
      forceRekeyOnSystem = "x86_64-linux";
    };
    secrets = {
      "atuin-password".rekeyFile = secrets + /atuin-password.age;
      "atuin-key".rekeyFile = secrets + /atuin-key.age;
      "nix-extra-access-tokens" = {
        rekeyFile = secrets + /nix-extra-access-tokens.age;
        mode = "0400";
        # owner = name.user;
      };
      "tailscale-oauth-secret".rekeyFile = secrets + /tailscale-oauth-secret.age;
      "u2f-mappings" = {
        rekeyFile = secrets + /u2f-mappings.age;
        group = "wheel";
        mode = "0440";
      };
      "host.syncthing-cert" = lib.mkIf (builtins.pathExists (perHost + /syncthing-cert.age)) {
        rekeyFile = perHost + /syncthing-cert.age;
        mode = "0440";
      };
      "host.syncthing-key" = lib.mkIf (builtins.pathExists (perHost + /syncthing-key.age)) {
        rekeyFile = perHost + /syncthing-key.age;
        mode = "0440";
      };
      "user.emily.password".rekeyFile = perUser "emily" + /password.age;
      "user.lpchaim.password".rekeyFile = perUser "lpchaim" + /password.age;
    };
  };
}
