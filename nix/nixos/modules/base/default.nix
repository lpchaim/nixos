{
  lib,
  pkgs,
  ...
}: {
  options.my.modules.enable =
    lib.mkEnableOption "base nixos config"
    // {default = true;};
  config = {
    environment.systemPackages = with pkgs; [
      android-udev-rules
      helix
      sbctl
      vim
      wget
    ];
    environment.sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
    };

    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;
    };
    stylix = {
      homeManagerIntegration = {
        autoImport = false;
        followSystem = true;
      };
      targets.plymouth.enable = false;
    };
    systemd = {
      targets.network-online.wantedBy = pkgs.lib.mkForce [];
      services.NetworkManager-wait-online.wantedBy = pkgs.lib.mkForce [];
    };
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
    };
  };
}
