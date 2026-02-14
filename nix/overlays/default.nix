{inputs, ...} @ args: let
  inherit (inputs.nixpkgs) lib;
  inherit (inputs.self.lib.loaders) loadNonDefault;
in {
  flake.overlays =
    (loadNonDefault ./. args)
    // {
      external = lib.composeManyExtensions [
        inputs.agenix-rekey.overlays.default
        inputs.nix-gaming.overlays.default
        inputs.nixneovimplugins.overlays.default
      ];
    };
}
