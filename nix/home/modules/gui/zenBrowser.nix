{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.my.gui.zen-browser;
in {
  imports = [
    inputs.zen-browser.homeModules.default
  ];

  options.my.gui.zen-browser.enable =
    lib.mkEnableOption "custom zen browser"
    // {default = config.my.gui.enable;};

  config = lib.mkIf cfg.enable {
    programs.zen-browser.enable = true;
  };
}
