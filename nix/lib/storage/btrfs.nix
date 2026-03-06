{lib, ...}: rec {
  primary.options = [
    "compress=zstd"
    "noatime"
  ];
  secondary.options =
    [
      "defaults"
      "auto"
      "exec"
      "nofail"
      "nosuid"
      "nodev"
      "x-gvfs-show"
    ]
    ++ primary.options;

  mkDiskoRootDisk = {
    device,
    bootSize ? "1024M",
    swapSize ? null,
  }: {
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
            subvolumes = {
              "@" = {
                mountpoint = "/";
                mountOptions = primary.options;
              };
              "@cache" = {
                mountpoint = "/var/cache";
                mountOptions = primary.options ++ ["nofail"];
              };
              "@home" = {
                mountpoint = "/home";
                mountOptions = primary.options;
              };
              "@log" = {
                mountpoint = "/var/log";
                mountOptions = primary.options ++ ["nofail"];
              };
              "@nix" = {
                mountpoint = "/nix";
                mountOptions = primary.options;
              };
              "@swap" = lib.mkIf (swapSize != null) {
                mountpoint = "/.swapvol";
                swap.swapfile.size = swapSize;
              };
            };
          };
        };
      };
    };
  };
}
