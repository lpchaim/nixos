{
  config,
  lib,
  self,
  pkgs,
  ...
}: {
  imports = builtins.attrValues self.nixosModules;

  my = {
    hardware = {
      enable = lib.mkDefault true;
      ups = {
        device = lib.mkDefault "/dev/serial/by-id/usb-NXP_SEMICONDUCTORS_MCU_VIRTUAL_COM_DEMO-if00";
        nut.driver = lib.mkDefault "gamatronic";
      };
    };
    kernel.enable = lib.mkDefault true;
    networking = {
      enable = lib.mkDefault true;
      ipv6.enable = lib.mkDefault true;
      networkManager.enable = lib.mkDefault true;
      tailscale.enable = lib.mkDefault true;
    };
    nix.enable = lib.mkDefault true;
    pipewire.enable = lib.mkDefault true;
    security.enable = lib.mkDefault true;
    services.enable = lib.mkDefault true;
    ssh.enable = lib.mkDefault true;
    syncthing.enable = lib.mkDefault true;
    theming.enable = lib.mkDefault true;
    users.enable = lib.mkDefault true;
    users.lpchaim.enable = lib.mkDefault true;
    zram.enable = lib.mkDefault true;
  };

  home-manager = {
    backupFileExtension = "backup";
    overwriteBackup = true;
    useGlobalPkgs = true;
    useUserPackages = true;
  };
  nixpkgs.hostPlatform = config.my.hostVars.system or "x86_64-linux";
  systemd = {
    targets.network-online.wantedBy = pkgs.lib.mkForce [];
    services.NetworkManager-wait-online.wantedBy = pkgs.lib.mkForce [];
    sleep.settings.Sleep = {
      AllowHibernation = "yes";
      AllowHybridSleep = "yes";
      AllowSuspend = "yes";
      AllowSuspendThenHibernate = "yes";
      HibernateDelaySec = "6h";
    };
  };
}
