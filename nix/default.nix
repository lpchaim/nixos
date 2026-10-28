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
    (importApply' ./home/homeConfigurations.nix)
    (importApply' ./home/homeModules.nix)
    (importApply' ./legacyPackages)
    (importApply' ./modules)
    (importApply' ./nixos/nixosConfigurations.nix)
    (importApply' ./nixos/nixosModules.nix)
    (importApply' ./overlays)
    (importApply' ./packages)
    (importApply' ../tests)
    inputs.agenix-rekey.flakeModule
    (inputs.files + /flake-module.nix)
    inputs.git-hooks-nix.flakeModule
  ];
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    _module.args.pkgs = self'.legacyPackages.pkgs;
    agenix-rekey = {
      inherit (self) nixosConfigurations;
      agePackage = pkgs.rage;
      homeConfigurations = self.lib.getStandaloneHomeConfigurations self;
    };
    files = {
      checks.enable = true;
      writer = {
        app = true;
        exeFilename = "write-files";
      };
    };
    formatter = pkgs.alejandra;
    pre-commit = {
      inherit pkgs;
      check.enable = true;
      settings = {
        enable = true;
        addGcRoot = true;
        hooks = {
          actionlint.enable = true;
          check-merge-conflicts.enable = true;
          alejandra.enable = true;
          ripsecrets.enable = true;
        };
      };
    };
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
