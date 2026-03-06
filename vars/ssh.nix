{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in {
  publicKeys = {
    github = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJMlCP3GL7MCCZHvQcbNyET6HGT2BbLuBkDQPZ2tk8TU github.com";
    tangled = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ+uIAmaOxc9or9djd+yUcmrPKcdjzIQhydOPrLipUbW tangled.com";
    perHost = lib.mapAttrs (_: host: host.pubKey) inputs.self.vars.hosts;
    perYubikey = {
      "25388788" = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOq7xMJxBehEnVZHYtUvrS51OjJskVQBkgMM/wIrQVKpAAAACnNzaDpnaXRodWI= ssh:github";
      "26583315" = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIL92uxU/gdt0slWOcy0Lx4LUPlgZmfiMTWR4GYAV2iZgAAAACnNzaDpnaXRodWI= ssh:github";
    };
  };
}
