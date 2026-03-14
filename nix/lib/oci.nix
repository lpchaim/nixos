{
  lib,
  self,
  ...
}: rec {
  mkDefaultContainer = lib.recursiveUpdate defaultContainer;
  defaultContainer = {
    environment = {
      TZ = self.vars.timezone;
      PUID = 1000;
      GUID = 1000;
    };
    volumes = [
      "/dev/rtc:/dev/rtc:ro"
      "/etc/localtime:/etc/localtime:ro"
      "/etc/timezone:/etc/timezone:ro"
    ];
    restart = "unless-stopped";
  };
}
