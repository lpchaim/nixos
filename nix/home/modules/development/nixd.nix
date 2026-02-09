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
    enable =
      lib.mkEnableOption "nixd"
      // {default = config.my.development.enable;};
    enableLsp =
      lib.mkEnableOption "nixd LSP"
      // {default = cfg.enable;};
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enableLsp {
      home.packages = [pkgs.nixd-lix];
    })
    (lib.mkIf cfg.enableLsp {
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
              inherit (inputs.self.lib.config) flake;
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
