{inputs, ...}: let
  inherit (inputs.self.lib.loaders) listNonDefault;
in {
  imports = listNonDefault ./.;

  sops = {
    defaultSopsFile = inputs.self + /secrets/default.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets = {
      password.neededForUsers = true;
      "tailscale/oauth/secret" = {};
    };
  };
}
