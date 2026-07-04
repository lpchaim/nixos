{
  home = {
    domain = "local";
    gateway = "10.0.0.1";
    routingPrefix = "10.0.0.0/8";
    subnetMask = "255.255.255.0";
  };
  oci.internal = {
    routingPrefix = "172.16.80.0/24";
  };
  oci.external = {
    routingPrefix = "10.10.250.0/24";
  };
}
