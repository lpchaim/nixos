{ config, ... }:

{
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../secrets/default.yaml;
    defaultSopsFormat = "yaml";
    secrets = {
      "example_key" = {
        path = "/home/lupec/test.txt";
      };
    };
  };
}
