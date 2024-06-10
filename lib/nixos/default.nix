{
  nixos = rec {
    getTraitModules = traits:
      map (mod: ./traits/${mod}.nix) traits;
  };
}
