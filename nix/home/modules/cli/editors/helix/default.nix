{
  config,
  inputs,
  lib,
  osConfig ? {},
  pkgs,
  ...
}: let
  cfg = config.my.cli.editors.helix;
  isNixos = osConfig != {};
in {
  options.my.cli.editors.helix.enable =
    lib.mkEnableOption "helix"
    // {default = config.my.cli.editors.enable;};
  config = lib.mkIf cfg.enable {
    programs.helix = {
      languages = {
        language-server.nixd = {
          command = "${lib.getExe pkgs.nixd-lix}";
          args = ["--semantic-tokens=true"];
          config.nixd = let
            inherit (inputs.self.lib.config) flake name;
            inherit (osConfig.networking) hostName;
            inherit (pkgs.stdenv.hostPlatform) system;
            absoluteFlakePath = builtins.replaceStrings ["~"] [config.home.homeDirectory] flake.path;
            getFlake = ''builtins.getFlake "${absoluteFlakePath}"'';
            hostConfig = ''(${getFlake}).nixosConfigurations.${hostName}'';
            homeConfig = ''(${getFlake}).homeConfigurations."${name.user}@desktop"'';
          in {
            nixpkgs.expr = "(${getFlake}).legacyPackages.${system}.pkgs";
            formatting.command = ["alejandra --quiet"];
            options =
              if isNixos
              then {
                nixos.expr = "${hostConfig}.options";
                home-manager.expr = "${hostConfig}.options.home-manager.users.type.getSubOptions []";
              }
              else {
                home-manager.expr = "${homeConfig}.options";
              };
          };
        };
      };
      enable = true;
      defaultEditor = true;
      settings = {
        editor = {
          bufferline = "always";
          color-modes = true;
          line-number = "relative";
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "block";
          };
          file-picker = {
            hidden = false;
          };
          indent-guides = {
            render = false;
            character = "╎";
            skip-levels = 1;
          };
          search = {
            smart-case = true;
            wrap-around = true;
          };
          statusline = {
            left = ["mode" "spinner" "file-name"];
            center = ["version-control"];
            right = ["diagnostics" "selections" "position" "total-line-numbers" "file-encoding"];
          };
        };
        keys = rec {
          normal = {
            "A-ç" = "switch_to_uppercase";
            "ç" = "switch_to_lowercase";
            "A-w" = "move_next_sub_word_start";
            "A-b" = "move_prev_sub_word_start";
            "A-e" = "move_next_sub_word_end";
            space = {
              "A-f" = "file_picker_in_current_buffer_directory";
            };
          };
          select = {
            inherit (normal) space;
            "A-w" = "extend_next_sub_word_start";
            "A-b" = "extend_prev_sub_word_start";
            "A-e" = "extend_next_sub_word_end";
          };
        };
      };
    };

    home.packages = with pkgs; [alejandra nixd-lix];
  };
}
