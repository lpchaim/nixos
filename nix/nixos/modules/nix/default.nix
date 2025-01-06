{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (inputs.self.lib) isNvidia;
  inherit (inputs.self.lib.config) nix;
  cfg = config.my.modules.nix;
in {
  options.my.modules.nix.enable = lib.mkEnableOption "nix";
  config = lib.mkIf (cfg.enable) {
    environment.sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
    };
    nix.gc = {
      automatic = let
        nhCfg = config.programs.nh;
      in
        !nhCfg.enable || !nhCfg.clean.enable;
      dates = "weekly";
    };
    nixpkgs.config =
      nix.pkgs.config
      // {enableCuda = isNvidia config;};
  };
}
