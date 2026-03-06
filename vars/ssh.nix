{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in {
  publicKeys = {
    github = ../keys/github.pub;
    tangled = ../keys/tangled.pub;
    perHost = lib.mapAttrs (_: host: host.pubKey) inputs.self.vars.hosts;
    perYubikey = {
      "25388788" = ../keys/yubikey-25388788.pub;
      "26583315" = ../keys/yubikey-26583315.pub;
    };
  };
}
