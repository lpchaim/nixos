{
  config,
  lib,
  options,
  ...
}: let
  inherit (lib.lpchaim) shared;
in
  lib.lpchaim.mkModule {
    inherit config;
    namespace = "my.networking.tailscale";
    options = {
      enable = lib.mkEnableOption "tailscale" // {default = true;};
      authKeyParameters =
        options.services.tailscale.authKeyParameters
        // {
          default.ephemeral = false;
          default.preauthorized = true;
        };
      trusted = lib.mkOption {
        description = "Whether to tag this device as trusted";
        type = lib.types.bool;
        default = false;
      };
      advertise.exitNode = lib.mkOption {
        description = "Whether to advertise an exit node";
        default = false;
        type = lib.types.bool;
      };
      advertise.tags = lib.mkOption {
        description = "ACL tags to advertise";
        default = ["nixos"];
        type = with lib.types; listOf str;
      };
    };
    configBuilder = cfg:
      lib.mkIf cfg.enable {
        services.tailscale = let
          tags =
            cfg.advertise.tags
            ++ lib.optionals cfg.trusted ["trusted"];
          formattedTags = lib.pipe tags [
            (map (it: "tag:${it}"))
            (builtins.concatStringsSep ",")
          ];
        in {
          inherit (cfg) authKeyParameters;
          enable = true;
          authKeyFile = config.sops.secrets."tailscale/oauth/secret".path;
          extraUpFlags =
            [
              "--accept-dns"
              "--accept-routes"
              "--advertise-tags=${formattedTags}"
              "--operator=${shared.defaults.name.user}"
              "--reset" # Forces unspecified arguments to default values
              "--ssh"
            ]
            ++ lib.optionals cfg.advertise.exitNode [
              "--advertise-exit-node"
            ];
          openFirewall = true;
          useRoutingFeatures = "both";
        };
      };
  }
