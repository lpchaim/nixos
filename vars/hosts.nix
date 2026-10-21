{
  desktop = {
    pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAVYoVIxGgrX+TCAbwZX6MwE/2wCOtyENOrMu/rTzlhs";
    system = "x86_64-linux";
    hostId = "ee8f47f9";
    ip.v4 = "10.0.0.50";
    interface.eth.name = "enp6s0";
    interface.bridge.mac = "02:97:f3:b2:b9:53";
  };
  laptop = {
    pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHh5IZnZipti8mCt0NPCVrJ5XTU2z+nb7d2hgMG4/B3C";
    system = "x86_64-linux";
    hostId = "a014571b";
    interface.wireless = "wlo1";
  };
  raspberrypi = {
    pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILr9pl4qaL/+DV//lhE5y6V7xJ2eh1BSlwNYD9L9a2sQ";
    system = "aarch64-linux";
    hostId = "ee66c96c";
    ip.v4 = "10.0.0.2";
    interface.eth.name = "enabcm6e4ei0";
    interface.bridge.mac = "02:6d:70:82:41:c3";
  };
}
