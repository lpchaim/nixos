{inputs, ...} @ args: let
  inherit (inputs.nixpkgs) lib;
  inherit (inputs.self.lib) nixFilesToAttrs;
in {
  flake.overlays =
    nixFilesToAttrs ./.
    |> lib.mapAttrs (_: path: import path args);
}
