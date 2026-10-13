{inputs, ...}: let
  inherit (inputs) self;
in {
  perSystem = {pkgs, ...}: {
    apps = {
      render-readme = {
        meta.description = "Renders README.md";
        program = pkgs.writeShellScriptBin "render-readme" ''
          export sampleconfig=$(cat '${self}/nix/nixos/configs/desktop/default.nix')
          envsubst < ./assets/README.md > ./README.md
        '';
      };
      update-cloudflare-ips = {
        meta.description = "Downloads cloudflare's trusted IP lists";
        program = pkgs.writeShellScriptBin "update-cloudflare-ips" ''
          wget --output-document 'assets/cloudflareIpsV4.txt' https://www.cloudflare.com/ips-v4/
          wget --output-document 'assets/cloudflareIpsV6.txt' https://www.cloudflare.com/ips-v6/
        '';
      };
    };
  };
}
