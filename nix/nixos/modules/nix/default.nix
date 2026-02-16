{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (config.my.config) nix;
  cfg = config.my.nix;
in {
  options.my.nix.enable = lib.mkEnableOption "nix";
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
    nix.package = pkgs.lixPackageSets.stable.lix;
    nixpkgs = {
      inherit (nix.pkgs) config;
      overlays = builtins.attrValues inputs.self.overlays;
    };
  };
}
