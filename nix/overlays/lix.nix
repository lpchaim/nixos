# As instructed on https://lix.systems/add-to-config/
{...}: final: prev: let
  inherit (prev) lib;
in {
  inherit
    (prev.lixPackageSets.stable)
    nixpkgs-review
    nix-eval-jobs
    nix-fast-build
    colmena
    ;

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
