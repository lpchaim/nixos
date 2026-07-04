{
  config,
  lib,
  self,
  ...
}: let
  cfg = config.my.nix;
  inherit (self.vars) nix;
in {
  options.my.nix.enable = lib.mkEnableOption "nix";
  config = lib.mkIf (cfg.enable) {
    environment.sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
    };

    nix.gc.automatic = !config.programs.nh.enable || !config.programs.nh.clean.enable;

    nixpkgs = nix.pkgs;
  };
}
