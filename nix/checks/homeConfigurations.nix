{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in {
  perSystem = {system, ...}: {
    checks =
      inputs.self.homeConfigurations
      |> lib.filterAttrs (_: home:
        (home.pkgs.stdenv.hostPlatform.system == system)
        && home._module.specialArgs.osConfig == {})
      |> lib.concatMapAttrs (name: home: {
        "homeConfigurations.${name}" = home.activationPackage;
      });
  };
}
