{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.virtualization.oci.compose;
in {
  options.my.virtualization.oci.compose = {
    enable =
      lib.mkEnableOption "compose files"
      // {default = config.my.virtualization.oci.enable;};
    project = lib.mkOption {
      description = "Project name for generated compose file";
      type = lib.types.str;
      default = "homelab";
    };
    attrs = lib.mkOption {
      type = lib.types.attrs;
    };
    prettyAttrs = lib.mkOption {
      type = lib.types.str;
    };
    file = lib.mkOption {
      type = lib.types.pathInStore;
    };
    text = lib.mkOption {
      type = lib.types.str;
    };
  };
  config = lib.mkIf cfg.enable {
    my.virtualization.oci.compose = {
      attrs = {
        inherit (config.my.virtualization.oci) networks;
        name = cfg.project;
        services = config.my.virtualization.oci.services.contents;
      };
      prettyAttrs =
        cfg.attrs
        |> lib.generators.toPretty {};
      text =
        cfg.attrs
        |> builtins.toJSON;
      file = pkgs.runCommand "compose-yaml" {buildInputs = [pkgs.remarshal];} ''
        remarshal --if json --of yaml > $out < ${pkgs.writeText "compose-json" cfg.text}
      '';
    };
  };
}
