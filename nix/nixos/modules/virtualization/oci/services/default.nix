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
  ];

  options.my.virtualization.oci.services = lib.mkOption {
    description = "freeform OCI compose services";
    type = lib.types.submodule {
      freeformType = format.type;
    };
    default = {};
    apply = lib.mapAttrs (_: service: self.lib.oci.mkDefaultContainer service);
  };
}
