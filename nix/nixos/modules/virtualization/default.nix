{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.virtualization;
in {
  imports = [
    ./oci
  ];

  options.my.virtualization = {
    enable = lib.mkEnableOption "virtualization";
  };

  config = lib.mkIf cfg.enable {
    my.users.defaultUserAttrs.extraGroups = ["libvirtd"];

    programs.virt-manager.enable = config.my.profiles.graphical;
    environment.systemPackages = [pkgs.virt-viewer];

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu.swtpm.enable = true;
        sshProxy = true;
      };
      spiceUSBRedirection.enable = true;
    };
  };
}
