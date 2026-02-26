{inputs, ...}: let
  inherit (inputs) self;
in {
  perSystem = {pkgs, ...}: {
    apps.render-readme = {
      meta.description = "Renders README.md";
      program = pkgs.writeShellScriptBin "render-readme" ''
        export sampleconfig=$(cat '${self}/nix/nixos/configs/desktop/default.nix')
        envsubst < ./assets/README.md > ./README.md
      '';
    };
  };
}
