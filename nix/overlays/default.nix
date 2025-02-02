{inputs, ...} @ args: let
  inherit (inputs.nixpkgs) lib;
  inherit (inputs.self.lib.loaders) loadNonDefault;
in {
  flake.overlays =
    (loadNonDefault ./. args)
    // {
      external = lib.composeManyExtensions [
        inputs.chaotic.overlays.default
        inputs.nh.overlays.default
        inputs.nix-gaming.overlays.default
        inputs.nixneovimplugins.overlays.default
      ];
    };
}
