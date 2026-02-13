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
        {buildInputs = with pkgs; [nushell starship];}
        ''
          nu --commands "
            starship preset nerd-font-symbols
            | from toml
            | merge deep (
              open '${config.programs.starship.settings |> builtins.toJSON |> (pkgs.writeText "starship-settings")}'
              | from json
            )
            | to toml
          " > $out
        '');
  };
}
