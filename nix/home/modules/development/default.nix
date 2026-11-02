{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.development;
in {
  imports = [
    ./nixd.nix
  ];

  options.my.development.enable = lib.mkEnableOption "development tools";

  config = lib.mkIf cfg.enable {
    programs = {
      devenv = {
        enable = true;
        package = pkgs.stable.devenv;
      };
      direnv = {
        enable = true;
        nix-direnv.enable = true;
        config.global.hide_env_diff = true;
      };
    };
  };
}
