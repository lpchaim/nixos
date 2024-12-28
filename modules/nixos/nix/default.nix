{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.lpchaim) shared;
in {
  nix = {
    package = pkgs.lix;
    extraOptions = ''
      experimental-features = flakes nix-command
    '';
    settings = shared.nix.settings;
    gc = {
      automatic = !config.programs.nh.clean.enable;
      dates = "weekly";
    };
  };
}
