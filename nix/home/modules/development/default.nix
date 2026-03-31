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
    home.packages = with pkgs; [
      stable.devenv
    ];
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global.hide_env_diff = true;
    };
  };
}
