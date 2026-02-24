{inputs, ...} @ topLevelArgs: let
  inherit (inputs.nixpkgs) lib;
  args = topLevelArgs // {inherit lib;};
  overlays = builtins.attrValues inputs.self.overlays;
in {
  config = import ./config.nix args;
  secrets = import ./secrets.nix;
  storage = import ./storage args;
  strings = import ./strings.nix args;

  callPackageWith = pkgs: path: extraArgs:
    lib.callPackageWith
    pkgs
    (
      if (lib.pathIsDirectory path && builtins.pathExists "${path}/package.nix")
      then "${path}/package.nix"
      else if (lib.pathIsDirectory path && builtins.pathExists "${path}/default.nix")
      then "${path}/default.nix"
      else path
    )
    extraArgs;
  callPackageRecursiveWith = pkgs: path: extraArgs:
    lib.packagesFromDirectoryRecursive {
      callPackage = lib.callPackageWith (pkgs // extraArgs);
      directory = path;
    }
    |> lib.filterAttrsRecursive (name: _: name != "default");
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
  nixFilesToAttrs = path:
    builtins.readDir path
    |> lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix")
    |> lib.concatMapAttrs (relativePath: _: {
      ${relativePath |> lib.removeSuffix ".nix"} = path + /${relativePath};
    });
  mkOneShotBootService =
    lib.recursiveUpdate
    {
      serviceConfig.Type = "oneshot";
      wantedBy = ["default.target"];
    };
  mkOneShotSleepService =
    lib.recursiveUpdate
    {
      unitConfig = {
        DefaultDependencies = "no";
        StopWhenUnneeded = "yes";
      };
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
      };
      before = ["sleep.target"];
      wantedBy = ["sleep.target"];
    };
}
