{inputs, ...}: let
  inherit (inputs) self;
in {
  perSystem = {
    config,
    inputs',
    lib,
    system,
    pkgs,
    ...
  }: {
    apps = let
      inherit (inputs'.nixpkgs-schemas.packages) nix;
      assetsRoot = "./assets/readme";
    in {
      generate-assets = {
        meta.description = "Creates README.md assets";
        program = pkgs.writeShellScriptBin "generate-assets" ''
          (${lib.getExe pkgs.eza} --tree --level 2 ./nix \
            2>/dev/null | tee /dev/tty > '${assetsRoot}/filestructure.txt'

          ${lib.getExe nix} flake show --all-systems . \
            2>/dev/null \
              | ${lib.getExe pkgs.ansifilter} \
              | tee /dev/tty > '${assetsRoot}/outputs.txt'
        '';
      };
      render-readme = {
        meta.description = "Renders README.md";
        program = pkgs.writeShellScriptBin "render-readme" ''
          export filestructure=$(cat '${assetsRoot}/filestructure.txt')
          export outputs=$(cat '${assetsRoot}/outputs.txt')
          export sampleconfig=$(cat '${self}/nix/nixos/configs/desktop/default.nix')
          envsubst < ./assets/README.md > ./README.md
        '';
      };
    };
  };
}
