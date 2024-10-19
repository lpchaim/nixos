{
  inputs,
  cell,
}: let
  inherit (inputs) self;
  inherit (inputs.cells.common.lib.internal.modules) loadModulesDefault;
in rec {
  default = internal ++ external;
  internal = loadModulesDefault (self + /modules/home);
  external = with inputs; [
    chaotic.nixosModules.default
    disko.nixosModules.disko
    home-manager.nixosModules.home-manager
    lanzaboote.nixosModules.lanzaboote
    nix-gaming.nixosModules.pipewireLowLatency
    nix-gaming.nixosModules.platformOptimizations
    nixos-generators.nixosModules.all-formats
    nur.nixosModules.nur
    sops-nix.nixosModules.sops
    stylix.nixosModules.stylix
  ];
}
