{inputs, ...} @ args: let
  inherit (inputs.nixpkgs) lib;
  inherit (inputs.self.lib.loaders) loadNonDefault;
in {
  flake.overlays =
    (loadNonDefault ./. args)
    // {
      external = lib.composeManyExtensions [
        inputs.nix-gaming.overlays.default
        inputs.nixneovimplugins.overlays.default
      ];
    };
}
