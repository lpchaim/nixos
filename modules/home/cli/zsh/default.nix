{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.modules.cli.zsh;
in {
  options.my.modules.cli.zsh.enable = lib.mkEnableOption "zsh";

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      inherit (config.home) shellAliases;
      enable = true;
      autosuggestion.enable = true;
      history = {
        extended = false;
        ignoreDups = true;
      };
      initExtra = ''
        export COLORTERM=truecolor
      '';
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "gitfast"
          "last-working-dir"
        ];
        theme = "agnoster";
      };
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.7.0";
            sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
          };
        }
      ];
    };
  };
}
