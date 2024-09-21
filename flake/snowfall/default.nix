{
  homeManagerModules,
  nixosModules,
  overlays,
}: {inputs, ...}: let
  inherit (snowfallLib.snowfall.attrs) merge-deep;
  inherit (snowfallLib.snowfall.internal.user-lib.home) mkHome;
  inherit (snowfallLib.snowfall.internal.user-lib.nixos) mkSystem;
  inherit (snowfallLib.snowfall.internal.user-lib.shared) defaults;
  snowfallLib = inputs.snowfall-lib.mkLib {
    inherit inputs;
    src = ../..;
    snowfall.namespace = defaults.name.user;
  };
  snowfallConfig = {
    inherit overlays;
    systems.modules.nixos = nixosModules;
    homes.modules = homeManagerModules;

    supportedSystems = import inputs.systems;
    channels-config = {allowUnfree = true;};

    outputs-builder = channels: {
      formatter = channels.nixpkgs.alejandra;
    };
    alias = {
      shells.default = "deploy";
    };
  };
  flake = merge-deep [
    (snowfallLib.mkFlake snowfallConfig)
    (inputs.flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages.homeConfigurations.minimal = mkHome {
        inherit system;
        inherit (snowfallConfig.homes) modules;
      };
      legacyPackages.nixosConfigurations.minimal = mkSystem {
        inherit system;
        modules = snowfallConfig.systems.modules.nixos;
      };
    }))
  ];
in {inherit flake;}
