{ unstable, ... }:

{
  boot = {
    kernelPackages = unstable.linuxPackages_zen;
    kernelModules = [
      "i2c-dev"
      "wireguard"
    ];
  };
  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';
}
