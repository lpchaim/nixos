{
  inputs,
  config,
  lib,
  osConfig ? {},
  pkgs,
  ...
}: let
  cfg = config.my.development.nixd;
  isNixos = osConfig != {};
in {
  options.my.development.nixd = {
    enable = lib.mkEnableOption "nixd";
    lsp.enable = lib.mkEnableOption "nixd LSP" // {default = cfg.enable;};
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [pkgs.nixd-lix];
    })
    (lib.mkIf (cfg.lsp.enable && config.programs.helix.enable) {
      programs.helix = {
        languages = {
          language = [
            {
              name = "nix";
              language-servers = lib.mkBefore ["nixd"];
            }
          ];
          language-server.nixd = {
            command = "${lib.getExe pkgs.nixd-lix}";
            args = ["--semantic-tokens=true"];
            config.nixd = let
              inherit (config.my.config) flake;
              inherit (pkgs.stdenv.hostPlatform) system;
              inherit (config.home) username;
              absoluteFlakePath = builtins.replaceStrings ["~"] [config.home.homeDirectory] flake.path;
              getFlake = ''builtins.getFlake "${absoluteFlakePath}"'';
              hostName = osConfig.networking.hostName or "desktop";
              hostConfig = ''(${getFlake}).nixosConfigurations.${hostName}'';
              homeConfig = ''(${getFlake}).homeConfigurations."${username}@${hostName}"'';
            in {
              nixpkgs.expr = "(${getFlake}).legacyPackages.${system}.pkgs";
              options =
                {home-manager.expr = "${homeConfig}.options";}
                // lib.optionalAttrs isNixos {nixos.expr = "${hostConfig}.options";};
            };
          };
        };
      };
    })
  ];
}
