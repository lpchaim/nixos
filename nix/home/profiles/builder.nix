{
  config,
  lib,
  osConfig ? {},
  pkgs,
  ...
}: let
  cfg = config.my.profiles.builder;
in {
  options.my.profiles.builder =
    lib.mkEnableOption "builder profile"
    // {default = osConfig.my.profiles.builder or false;};
  config = lib.mkIf cfg {
    programs.fish.interactiveShellInit = ''
      ${lib.getExe pkgs.panix} completion -c fish | source
    '';
  };
}
