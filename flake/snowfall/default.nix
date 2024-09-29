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
  snowfallConfig = rec {
    inherit overlays;
    supportedSystems = import inputs.systems;
    systems.modules.nixos = nixosModules;
    homes.modules = homeManagerModules;

    channels-config = {allowUnfree = true;};
    channels.nixpkgs-cuda.config = channels-config // {cudaSupport = true;};
    channels.nixpkgs-steamdeck.overlaysBuilder = channels: [
      inputs.jovian.overlays.default
    ];

    systems.hosts.desktop.channelName = "nixpkgs-cuda";
    systems.hosts.steamdeck.channelName = "nixpkgs-steamdeck";
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
