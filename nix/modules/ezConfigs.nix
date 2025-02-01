{inputs, ...}: let
  inherit (inputs) self;
  inherit (inputs.nixpkgs) lib;
in {
  imports = [
    inputs.ez-configs.flakeModule
  ];

  ezConfigs = let
    root = "${self}/nix";
  in {
    inherit root;
    globalArgs = {inherit inputs;};
    nixos = rec {
      configurationsDirectory = "${root}/nixos/configs";
      modulesDirectory = "${root}/nixos/modules";
      hosts = lib.pipe configurationsDirectory [
        builtins.readDir
        (lib.filterAttrs (_: type: type == "directory"))
        (lib.concatMapAttrs (name: _: {
          ${name}.userHomeModules = ["lpchaim"];
        }))
      ];
    };
    home = {
      configurationsDirectory = "${root}/home/configs";
      modulesDirectory = "${root}/home/modules";
      users."cheina@pc079".standalone = {
        inherit (self.legacyPackages.x86_64-linux) pkgs;
        enable = true;
      };
    };
  };
}
