# As instructed on https://lix.systems/add-to-config/
{inputs, ...}: final: prev: {
  inherit
    (prev.lixPackageSets.stable)
    nixpkgs-review
    nix-eval-jobs
    nix-fast-build
    colmena
    ;
}
