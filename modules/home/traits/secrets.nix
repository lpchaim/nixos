{ lib, ... }:

let
  inherit (lib.snowfall) fs;
in
{
  sops = {
    defaultSopsFile = fs.get-file "secrets/default.yaml";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = { };
  };
}
