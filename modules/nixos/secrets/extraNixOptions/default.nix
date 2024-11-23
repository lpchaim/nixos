{
  config,
  lib,
  ...
}: let
  inherit (lib.lpchaim.shared) defaults;
in {
  sops.secrets."nix/extraAccessTokens" = {
    mode = "0400";
    owner = defaults.name.user;
  };
  nix.extraOptions = ''
    !include ${config.sops.secrets."nix/extraAccessTokens".path}
  '';
}
