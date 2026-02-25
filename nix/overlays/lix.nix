# As instructed on https://lix.systems/add-to-config/
{...}: final: prev: let
  inherit (prev) lib;
  rev = "stable";
in {
  # Workaround for infrec found here https://github.com/NixOS/nixpkgs/pull/445223#issuecomment-3330902652
  nix = final.lixPackageSets.${rev}.lix;
  inherit
    (final.lixPackageSets.${rev})
    colmena
    nix-direnv
    nix-eval-jobs
    nix-fast-build
    nixpkgs-review
    nix-serve-ng
    ;
  lixPackageSets = prev.lixPackageSets.override {
    inherit
      (prev)
      colmena
      nix-direnv
      nix-fast-build
      nixpkgs-review
      nix-serve-ng
      ;
  };

  # Adapted from https://github.com/nix-community/nixd/issues/704#issuecomment-3688024705
  nixd-lix = prev.symlinkJoin {
    name = "nixd-lix";

    inherit (prev.nixd) meta;

    paths = [prev.nixd];

    preferLocalBuild = true;

    nativeBuildInputs = [
      prev.makeWrapper
    ];

    postBuild = ''
      wrapProgram $out/bin/nixd \
        --prefix PATH ":" ${lib.makeBinPath [prev.nix]} \
        --run ${
        lib.escapeShellArg
        # sh
        ''
          export NIX_CONFIG="$(${lib.getExe prev.gnused} -E 's/ pipe-operator( |$)/ pipe-operators\1/' /etc/nix/nix.conf)
          $NIX_CONFIG"
        ''
      }
    '';
  };
}
