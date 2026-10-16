{self, ...} @ inputs:
inputs.flake-parts.lib.mkFlake
{inherit inputs;}
({flake-parts-lib, ...}: let
  inherit (flake-parts-lib) importApply;
  inherit (inputs.nixpkgs) lib;
  specialArgs = {inherit inputs lib self;};
  import' = path: import path specialArgs;
  importApply' = path: importApply path specialArgs;
  systems = ["aarch64-linux" "x86_64-linux"];
in {
  inherit systems;
  imports = [
    (importApply' ./apps)
    (importApply' ./checks)
    (importApply' ./devShells)
    (importApply' ./flakeModules)
    (importApply' ./legacyPackages)
    (importApply' ./overlays)
    (importApply' ./packages)
    (importApply' ./tests)
  ];
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    _module.args.pkgs = self'.legacyPackages.pkgs;
    formatter = pkgs.alejandra;
  };
  flake = {
    inherit systems;
    lib = import' ./lib;
    nixConfig = self.vars.nix.settings;
    schemas =
      inputs.flake-schemas.schemas
      // (import' ./schemas);
    vars = import' ../vars;
  };
})
