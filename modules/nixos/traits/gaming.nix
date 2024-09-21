{pkgs, ...}: {
  hardware.steam-hardware.enable = true;
  programs.steam = {
    enable = true;
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
  environment.systemPackages = with pkgs; [
    gamemode
    # osu-stable # @TODO Reenable when I figure out why nix-gaming's cachix doesn't ever seem to work
    parsec-bin
    # wine-discord-ipc-bridge
  ];
  services.pipewire.lowLatency.enable = true;
  security.rtkit.enable = true; # make pipewire realtime-capable
}
