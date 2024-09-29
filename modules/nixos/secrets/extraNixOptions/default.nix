{config, ...}: {
  sops.secrets."nix/extraAccessTokens".mode = "0440";
  nix.extraOptions = ''
    !include ${config.sops.secrets."nix/extraAccessTokens".path}
  '';
}
