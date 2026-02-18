{inputs, ...} @ topLevelArgs: let
  inherit (inputs.nixpkgs) lib;
  args = topLevelArgs // {inherit lib;};
  overlays = builtins.attrValues inputs.self.overlays;
in {
  config = import ./config.nix args;
  loaders = import ./loaders.nix args;
  secrets = import ./secrets.nix;
  storage = import ./storage args;
  strings = import ./strings.nix args;

  mkPkgs = {
    system,
    nixpkgs ? inputs.nixpkgs,
  }:
    import nixpkgs {
      inherit system overlays;
      allowUnfree = true;
    };
  isNvidia = config: let
    drivers = config.services.xserver.videoDrivers or [];
  in
    builtins.elem "nvidia" drivers;
  carapaceSpecFromNuScript = script: let
    inherit (script) name system;
    inherit (inputs.self.legacyPackages.${system}) scripts pkgs;
  in
    pkgs.runCommand
    "nushell-carapace-spec-${name}"
    {
      buildInputs = with scripts; [
        nu-generate-carapace-spec
        nu-inspect
      ];
    }
    ''
      cat '${lib.getExe script}' \
      | nu-inspect --name '${name}' \
      | nu-generate-carapace-spec \
      > $out
    '';
}
