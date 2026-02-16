{
  config,
  inputs,
  ...
}: let
  inherit (config.my.config) name;
in {
  sops.secrets."nix/extraAccessTokens" = {
    mode = "0400";
    owner = name.user;
  };
  nix.extraOptions = ''
    !include ${config.sops.secrets."nix/extraAccessTokens".path}
  '';
}
