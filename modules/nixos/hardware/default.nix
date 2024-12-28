{
  config,
  lib,
  pkgs,
  ...
}: {
  hardware = {
    bluetooth = {
      enable = true;
      settings = {
        General = {
          FastConnectable = true;
        };
      };
    };
    graphics = let
      getExtraPackages = p:
        with p;
          lib.optionals pkgs.stdenv.isx86_64 [
            intel-media-driver
            intel-vaapi-driver
          ];
    in {
      enable = lib.mkDefault false;
      enable32Bit = config.hardware.graphics.enable && pkgs.stdenv.isx86_64;
      extraPackages = lib.mkIf config.hardware.graphics.enable (getExtraPackages pkgs);
      extraPackages32 = lib.mkIf config.hardware.graphics.enable (getExtraPackages pkgs.pkgsi686Linux);
    };
  };
}
