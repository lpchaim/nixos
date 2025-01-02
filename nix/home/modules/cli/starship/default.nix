args @ {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.modules.cli.starship;
  settings = import ./settings.nix;
  util = import ./util.nix args;
in {
  options.my.modules.cli.starship.enable = lib.mkEnableOption "starship";

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = let
        tomlContents = util.getPresetFiles ["nerd-font-symbols"];
        allSettings = (map fromTOML tomlContents) ++ [settings];
        mergedSettings = builtins.foldl' (l: r: pkgs.lib.recursiveUpdate l r) {} allSettings;
      in
        mergedSettings;
    };
  };
}
