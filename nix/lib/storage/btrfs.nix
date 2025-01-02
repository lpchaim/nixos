{
  mkStorage = {
    device,
    bootSize ? "512M",
    swapSize,
  }: {
    disko.devices = {
      disk = {
        vdb = {
          inherit device;
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                type = "EF00";
                size = bootSize;
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
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
                      mountOptions = ["compress=zstd"];
                      mountpoint = "/";
                    };
                    # Subvolume name is the same as the mountpoint
                    "@home" = {
                      mountOptions = ["compress=zstd"];
                      mountpoint = "/home";
                    };
                    # Parent is not mounted so the mountpoint must be set
                    "@nix" = {
                      mountOptions = ["compress=zstd" "noatime"];
                      mountpoint = "/nix";
                    };
                    "@swap" = {
                      mountpoint = "/.swapvol";
                      swap = {
                        swapfile.size = swapSize;
                      };
                    };
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
