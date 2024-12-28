{lib, ...}: {
  sops = {
    defaultSopsFile = lib.snowfall.fs.get-file "secrets/default.yaml";
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets = {
      password.neededForUsers = true;
      "tailscale/oauth/secret" = {};
    };
  };
}
