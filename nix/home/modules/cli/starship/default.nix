{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.cli.starship;
in {
  options.my.cli.starship.enable = lib.mkEnableOption "starship";

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = {
        aws.disabled = true;
        php.symbol = " ";
      };
    };
    home.file.${config.programs.starship.configPath}.source =
      lib.mkForce
      (pkgs.runCommand
        "starship-settings"
        {buildInputs = [pkgs.nushell pkgs.starship];}
        ''
          nu --commands "
            starship preset nerd-font-symbols
            | from toml
            | merge deep (
              open ${pkgs.writeText "starship-settings" (builtins.toJSON config.programs.starship.settings)}
              | from json
            )
            | to toml
          " \
          > $out
        '');
  };
}
