{ unstable, ... }:

{
  boot = {
    kernelPackages = unstable.linuxPackages_zen;
    kernelModules = [
      "wireguard"
    ];
  };
}
