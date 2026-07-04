{
  lib,
  pkgs,
  self,
  ...
}: let
  format = pkgs.formats.yaml {};
in {
  imports = [
    ./cloudflare-ddns.nix
    ./gotify.nix
  ];

  options.my.virtualization.oci.services.contents = lib.mkOption {
    description = "freeform OCI compose services";
    type = lib.types.submodule {
      freeformType = format.type;
    };
    default = {};
    apply = lib.mapAttrs (_: service: self.lib.oci.mkDefaultContainer service);
  };
}
