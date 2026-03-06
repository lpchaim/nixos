{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (self.vars) flake;
  cfg = config.my.cli.extras;
in {
  options.my.cli.extras.enable = lib.mkEnableOption "CLI extras";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      asciinema
      charm-freeze
      ffmpeg
      imagemagick
      inotify-tools
      jocalsend
      nix-output-monitor
      python312Packages.howdoi
      (symlinkJoin {
        name = "termshot";
        paths = [termshot];
        nativeBuildInputs = [makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/termshot \
            --add-flags "--font ${nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFontMono-Regular.ttf"
        '';
      })
    ];

    programs = {
      nh = {
        enable = lib.mkDefault true;
        flake = builtins.replaceStrings ["~"] [config.home.homeDirectory] flake.path;
      };
      nix-index.enable = true;
      nix-index-database.comma.enable = true;
    };

    home.file."${config.xdg.configHome}/freeze/user.json".text = builtins.toJSON {
      font.family = "JetBrainsMono Nerd Font";
      font.file = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFontMono-Regular.ttf";
      font.ligatures = true;
      font.size = config.stylix.fonts.sizes.terminal;
      shadow = false;
      window = false;
      show-line-numbers = true;
    };
  };
}
