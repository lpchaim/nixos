{
  config,
  inputs,
  ...
}: let
  secrets = ../../../../secrets;
  identities = secrets + /identities;
  perHost = secrets + /perHost/${config.networking.hostName};
  perUser = user: secrets + /perUser/${user};
in {
  imports = [
    ./atuin.nix
    ./extraNixOptions.nix
  ];

  age = {
    rekey = {
      # This is per host, specify per config later
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNf+oynlWr+Xq3UYKpCy8ih/w9sT6IuIKAtYjo6sfJr";

      masterIdentities = [
        # (identities + /id_ed25519_sk_rk_26583315.pub)
        # (identities + /id_ed25519_sk_rk_25388788.pub)
        (identities + /age-yubikey-identity-26583315.txt)
        (identities + /age-yubikey-identity-25388788.txt)
      ];
      localStorageDir = secrets + /rekeyed/${config.networking.hostName};
      storageMode = "local";
    };
    secrets = {
      "atuin-password".rekeyFile = secrets + /atuin-password.age;
      "atuin-key".rekeyFile = secrets + /atuin-key.age;
      "nix-extra-access-tokens".rekeyFile = secrets + /nix-extra-access-tokens.age;
      "tailscale-oauth-secret".rekeyFile = secrets + /tailscale-oauth-secret.age;
      "u2f-mappings".rekeyFile = secrets + /u2f-mappings.age;
      "host.syncthing-cert".rekeyFile = perHost + /syncthing-cert.age;
      "host.syncthing-key".rekeyFile = perHost + /syncthing-key.age;
      "user.emily.password".rekeyFile = perUser "emily" + /password.age;
      "user.lpchaim.password".rekeyFile = perUser "lpchaim" + /password.age;
    };
  };

  sops = {
    defaultSopsFile = inputs.self + /secrets/default.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets = {
      "tailscale/oauth/secret" = {};
      "user/emily/password".neededForUsers = true;
      "user/lpchaim/password".neededForUsers = true;
    };
  };
}
