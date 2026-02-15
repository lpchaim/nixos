{
  config,
  inputs,
  lib,
  options,
  ...
}: let
  inherit (inputs.self.lib.config) name;
  inherit (inputs.self.lib.secrets) mkSecret;
  cfg = config.my.networking.tailscale;
in {
  options.my.networking.tailscale = {
    enable = lib.mkEnableOption "tailscale";
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
  config = lib.mkIf cfg.enable {
    age.secrets = {
      "tailscale-oauth-secret" = mkSecret "tailscale-oauth-secret" {};
    };

    services.tailscale = let
      tags =
        cfg.advertise.tags
        ++ lib.optionals cfg.trusted ["trusted"];
      formattedTags =
        tags
        |> map (it: "tag:${it}")
        |> builtins.concatStringsSep ",";
    in {
      inherit (cfg) authKeyParameters;
      enable = true;
      authKeyFile = config.age.secrets."tailscale-oauth-secret".path;
      extraUpFlags =
        [
          "--accept-dns"
          "--accept-routes"
          "--advertise-tags=${formattedTags}"
          "--operator=${name.user}"
          "--reset" # Forces unspecified arguments to default values
          "--ssh"
        ]
        ++ lib.optionals cfg.advertise.exitNode [
          "--advertise-exit-node"
        ];
      openFirewall = true;
      useRoutingFeatures = "both";
    };
    systemd.services.tailscaled.restartIfChanged = false;
  };
}
