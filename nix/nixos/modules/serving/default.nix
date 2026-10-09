{
  config,
  lib,
  ...
}: let
  cfg = config.my.serving;
in {
  options.my.serving.enable = lib.mkEnableOption "serving tweaks";

  imports = [
    ./ddns.nix
    ./storage.nix
  ];

  config = lib.mkIf cfg.enable {
    my = {
      virtualization.oci.enable = true;
    };
  };
}
