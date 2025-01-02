{pkgs, ...}: let
  uefiFirmware = pkgs.fetchzip {
    url = "https://github.com/pftf/RPi4/releases/download/v1.38/RPi4_UEFI_Firmware_v1.38.zip";
    hash = "sha256-0axfcb5fhbhkqvfysy7xqk2xi8k3lsx4146nms5315r4ynhh897q=";
  };
in {
  disko.devices = {
    disk = {
      vdb = {
        device = "/dev/disk/by-uuid/322a6d8e-f946-4d60-98a3-dd1af1373c79";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "1GB";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                postMountHook = ''
                  cp -r ${uefiFirmware} /boot
                '';
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"]; # Override existing partition
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  # Subvolume name is different from mountpoint
                  "@" = {
                    mountOptions = ["compress=zstd" "noatime"];
                    mountpoint = "/";
                  };
                  # Subvolume name is the same as the mountpoint
                  "@home" = {
                    mountOptions = ["compress=zstd" "noatime"];
                    mountpoint = "/home";
                  };
                  # Parent is not mounted so the mountpoint must be set
                  "@nix" = {
                    mountOptions = ["compress=zstd" "noatime"];
                    mountpoint = "/nix";
                  };
                  "@swap" = {
                    mountpoint = "/.swapvol";
                    swap.swapfile.size = "4GB";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
