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

    channels-config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-27.3.11"
      ];
    };
    channels.nixpkgs-cuda.config = channels-config // {cudaSupport = true;};
    channels.nixpkgs-steamdeck.overlaysBuilder = channels: [
      inputs.jovian.overlays.default
    ];

    systems.hosts.desktop.channelName = "nixpkgs-cuda";
    systems.hosts.steamdeck.channelName = "nixpkgs-steamdeck";
  };
  flake = snowfallLib.mkFlake snowfallConfig;
in {inherit flake;}
