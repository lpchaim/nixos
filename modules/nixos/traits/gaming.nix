{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.lpchaim) mkModule;
  inherit (lib.lpchaim.shared) defaults;
in
  mkModule {
    inherit config;
    namespace = "my.gaming";
    options = {
      enable = lib.mkEnableOption "gaming tweaks";
      steam.enable = lib.mkEnableOption "steam tweaks" // {default = config.my.gaming.enable;};
    };
    configBuilder = cfg:
      lib.mkMerge [
        (lib.mkIf cfg.enable {
          environment.systemPackages = with pkgs; [
            # osu-stable # @TODO Reenable when I figure out why nix-gaming's cachix doesn't ever seem to work
            parsec-bin
            # wine-discord-ipc-bridge
            (pkgs.wrapOBS {
              plugins = (
                (with pkgs.obs-studio-plugins; [
                  input-overlay
                  obs-pipewire-audio-capture
                  obs-scale-to-sound
                  obs-vaapi
                  obs-vkcapture
                  wlrobs
                ])
                ++ (lib.optionals (lib.elem "nvidia" config.services.xserver.videoDrivers) [
                  pkgs.obs-studio-plugins.obs-nvfbc
                ])
              );
            })
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

          users.extraUsers.${defaults.name.user}.extraGroups = ["gamemode"];
        })
        (lib.mkIf cfg.steam.enable {
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
            extraCompatPackages = let
              geVersions = ["9-10"];
              protonGePackages =
                map
                (v:
                  pkgs.proton-ge-bin.overrideAttrs
                  (final: prev: {
                    pname = prev.pname + v;
                    version = "GE-Proton${v}";
                  }))
                geVersions;
            in
              protonGePackages;
            gamescopeSession.enable = true;
            remotePlay.openFirewall = true;
            dedicatedServer.openFirewall = true;
            localNetworkGameTransfers.openFirewall = true;
            platformOptimizations.enable = true;
            protontricks.enable = true;
          };
          hardware.steam-hardware.enable = true;
        })
      ];
  }
