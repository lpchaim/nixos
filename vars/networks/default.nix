{
  home = {
    domain = "local";
    gateway = "10.0.0.1";
    gatewayV6 = "fe80::264b:feff:fe42:9f48";
    routingPrefix = "10.0.0.0/8";
    subnetMask = "255.255.255.0";
  };
  tailscale = {
    routingPrefix = "100.0.0.0/8";
    nodes = import ./tailscale-nodes.nix;
  };
  oci.internal = {
    routingPrefix = "172.16.80.0/24";
  };
  oci.external = {
    routingPrefix = "10.10.250.0/24";
  };
}
