{inputs, ...} @ args: let
  inherit (inputs.nixpkgs) lib;
  inherit (inputs.self.lib.loaders) importNonDefault;
in
  (importNonDefault ./. args)
  ++ [
    (final: prev: {
      pythonPackagesExtensions =
        prev.pythonPackagesExtensions
        ++ [
          (pyfinal: pyprev: {
            mss = pyprev.mss.overridePythonAttrs (oldAttrs: {
              doCheck = false;
              prePatch = ''
                rm -rf src/tests/*
              '';
            });
          })
        ];
    })
    inputs.chaotic.overlays.default
    inputs.nh.overlays.default
    inputs.nix-gaming.overlays.default
    inputs.nixneovimplugins.overlays.default
  ]
