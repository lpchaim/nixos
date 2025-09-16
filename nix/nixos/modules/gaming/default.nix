{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.self.lib) isNvidia;
  inherit (inputs.self.lib.config) name;
  cfg = config.my.gaming;
in {
  options.my.gaming = {
    enable = lib.mkEnableOption "gaming tweaks";
    steam.enable =
      lib.mkEnableOption "steam tweaks"
      // {default = config.my.gaming.enable;};
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        lutris
        osu-lazer-bin
        parsec-bin
        # wine-discord-ipc-bridge
        (pkgs.wrapOBS {
          plugins = with pkgs.obs-studio-plugins; [
            input-overlay
            obs-pipewire-audio-capture
            obs-scale-to-sound
            obs-vaapi
            obs-vkcapture
            wlrobs
          ];
        })
        protonup-qt
      ];

      services.pipewire.lowLatency.enable = true;
      security.rtkit.enable = true; # make pipewire realtime-capable

      programs.gamemode = {
        enable = true;
        enableRenice = true;
      };
      programs.gamescope = {
        enable = true;
        capSysNice = true;
      };
      security.wrappers.gamescope.source = lib.mkForce (lib.getBin pkgs.gamescope);

      users.extraUsers.${name.user}.extraGroups = ["gamemode"];
    })
    (lib.mkIf cfg.steam.enable {
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
