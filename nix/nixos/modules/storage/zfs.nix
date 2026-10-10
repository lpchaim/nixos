{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.storage.zfs;
in {
  options.my.storage.zfs.enable = lib.mkEnableOption "ZFS";

  config = lib.mkIf (cfg.enable) {
    boot = {
      kernelPackages = lib.mkForce (pkgs.linuxKernel.packages
        |> lib.filterAttrs (
          name: kernelPackages:
            ((builtins.match "linux_[0-9]+_[0-9]+" name) != null)
            && (builtins.tryEval kernelPackages).success
            && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
        )
        |> builtins.attrValues
        |> lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version))
        |> lib.last);
      supportedFilesystems = ["zfs"];
      zfs.forceImportRoot = false;
    };

    environment.systemPackages = with pkgs; [
      zfs
    ];
  };
}
