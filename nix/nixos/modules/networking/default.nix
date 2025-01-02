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
  };
}
