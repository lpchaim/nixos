{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in {
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem = {
    config,
    pkgs,
    ...
  }: {
    treefmt = {
      flakeCheck = false; # The pre-commit hook already takes care of this
      flakeFormatter = true;
      programs = {
        alejandra = {
          enable = true;
          includes = ["*.nix"];
          excludes = [
            "nix/home/modules/de/hyprland/binds*"
            "nix/home/modules/de/hyprland/default.nix"
          ];
        };
        just = {
          enable = true;
          indentation = "  ";
          includes = [
            "justfile"
            "just/*.just"
          ];
        };
      };
      settings = {
        formatter = {
          action-validator = {
            command = lib.getExe pkgs.action-validator;
            includes = [
              ".github/actions/*"
              ".github/workflows/*"
            ];
          };
          nufmt = {
            command = lib.getExe pkgs.nufmt;
            options = ["--config=${./nufmt.nuon}"];
            includes = ["*.nu"];
            excludes = ["*"];
          };
        };
        excludes = [
          "CHANGELOG.md"
          "README.md"
          "assets/*"
          "secrets/*"
          "tests/_snapshots/*"
        ];
      };
    };

    pre-commit.settings.hooks = {
      check-merge-conflicts.enable = true;
      ripsecrets.enable = true;
      treefmt-custom = {
        enable = true;
        name = "treefmt";
        description = "Run treefmt";
        entry = "${lib.getExe config.treefmt.build.wrapper} --ci";
        priority = 10;
      };
    };
  };
}
