{
  lib,
  pkgs,
  ...
}: let
  format = pkgs.formats.yaml {};
in {
  options.my.virtualization.oci.networks = lib.mkOption {
    description = "freeform OCI compose networks";
    type = lib.types.submodule {
      freeformType = format.type;
    };
    default = {};
  };
}
