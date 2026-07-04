{lib, ...}: rec {
  primary.options = [
    "defaults"
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
    swapSize ? null,
    espSize ? "1024M",
    espIndex ? 1,
    rootIndex ? 2,
  }: {
    inherit device;
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          device = "${device}-part${toString espIndex}";
          type = "EF00";
          size = espSize;
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        root = {
          device = "${device}-part${toString rootIndex}";
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
                mountOptions = primary.options ++ ["nofail"];
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
                swap.swapfile.options = ["defaults" "nofail"];
                swap.swapfile.size = swapSize;
              };
            };
          };
        };
      };
    };
  };
}
