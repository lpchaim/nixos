{ config, lib, pkgs, ... }:

let
  namespace = [ "my" "services" "swayosd" ];
  cfg = lib.getAttrFromPath namespace config;
in
{
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "swayosd libinput backend";
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ pkgs.swayosd ];
    services.dbus.packages = [ pkgs.swayosd ];
    systemd.services.swayosd-libinput-backend = {
      enable = true;
      description = "SwayOSD LibInput backend for listening to certain keys like CapsLock, ScrollLock, VolumeUp, etc...";
      documentation = [ "https://github.com/ErikReider/SwayOSD" ];
      wantedBy = [ "graphical.target" ];
      partOf = [ "graphical.target" ];
      after = [ "graphical.target" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "org.erikreider.swayosd";
        ExecStart = [
          "" # Yeah, this has to be here to reset the override
          "${pkgs.swayosd}/bin/swayosd-libinput-backend"
        ];
        Restart = "on-failure";
      };
    };
  };
}
