{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.gaming;
in {
  imports = [
    ./obs.nix
  ];

  options.my.gaming = {
    enable = lib.mkEnableOption "gaming tweaks";
    freesmlauncher.enable = lib.mkEnableOption "freesmlauncher";
    lutris.enable = lib.mkEnableOption "lutris";
    osu.enable = lib.mkEnableOption "osu";
    steam.enable = lib.mkEnableOption "steam tweaks" // {default = cfg.enable;};
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      my.users.defaultUserAttrs.extraGroups = ["gamemode"];

      environment.systemPackages =
        lib.optionals cfg.freesmlauncher.enable [inputs.freesmlauncher.packages.${pkgs.stdenv.hostPlatform.system}.freesmlauncher]
        ++ lib.optionals cfg.lutris.enable [pkgs.lutris]
        ++ lib.optionals cfg.osu.enable [pkgs.osu-lazer-bin];

      programs = {
        gamemode = {
          enable = true;
          enableRenice = true;
        };
        gamescope = {
          enable = true;
          capSysNice = true;
        };
      };

      security.rtkit.enable = true; # make pipewire realtime-capable

      services.pipewire.lowLatency.enable = true;
    })
    (lib.mkIf cfg.steam.enable {
      environment.systemPackages = [pkgs.protonup-qt];
      hardware.steam-hardware.enable = true;
      programs.steam = {
        enable = true;
        extest.enable = true;
        extraPackages = with pkgs; [
          gamescope
          mangohud
        ];
        package = pkgs.steam.override {
          extraEnv = {
            MANGOHUD = true;
            OBS_VKCAPTURE = true;
          };
        };
        gamescopeSession.enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        platformOptimizations.enable = true;
        protontricks.enable = true;
      };
    })
  ];
}
