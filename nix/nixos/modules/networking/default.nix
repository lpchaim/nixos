{
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        57621 # spotify local discovery
        5353 # spotify cast discovery
      ];
    };
    dhcpcd.extraConfig = let
      wifiOffset = 2000;
    in ''
      ssid Lpchaim5G
      metric ${toString (wifiOffset - 20)}

      ssid Lpchaim
      metric ${toString (wifiOffset - 10)}
    '';
    networkmanager = {
      enable = true;
      settings = {
        connection-ethernet = {
          "match-device" = "type:ethernet";
          "connection.autoconnect-priority" = 150;
        };
        connection-wifi = {
          "match-device" = "type:wifi";
          "connection.autoconnect-priority" = 50;
        };
      };
    };
  };
}
