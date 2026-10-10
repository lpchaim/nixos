{pkgs, ...}: {
  my.users.defaultUserAttrs.extraGroups = ["i2c"];

  boot.kernelModules = ["i2c-dev"];

  environment.systemPackages = with pkgs; [
    qmk_hid
    qmk-udev-rules
  ];

  hardware = {
    block = {
      defaultScheduler = "kyber";
      defaultSchedulerRotational = "bfq";
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          FastConnectable = true;
        };
      };
    };
    i2c.enable = true;
    keyboard.qmk = {
      enable = true;
      keychronSupport = true;
    };
    sensor.hddtemp = {
      enable = true;
      unit = "C";
      drives = ["/dev/disk/by-path/*"];
    };
  };
}
