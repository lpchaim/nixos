{
  desktop = {
    pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAVYoVIxGgrX+TCAbwZX6MwE/2wCOtyENOrMu/rTzlhs";
    system = "x86_64-linux";
    ip.v4 = "10.0.0.50";
  };
  laptop = {
    pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHh5IZnZipti8mCt0NPCVrJ5XTU2z+nb7d2hgMG4/B3C";
    system = "x86_64-linux";
  };
  raspberrypi = {
    pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILr9pl4qaL/+DV//lhE5y6V7xJ2eh1BSlwNYD9L9a2sQ";
    system = "aarch64-linux";
    ip.v4 = "10.0.0.2";
  };
}
