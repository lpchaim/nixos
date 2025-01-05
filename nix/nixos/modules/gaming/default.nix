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
        # osu-stable # @TODO Reenable when I figure out why nix-gaming's cachix doesn't ever seem to work
        parsec-bin
        lutris
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
            ++ (lib.optionals (isNvidia config) [
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
        extraCompatPackages = builtins.attrValues pkgs.proton-ge-bin-versions;
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
