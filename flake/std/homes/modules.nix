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
    ags.homeManagerModules.default
    chaotic.homeManagerModules.default
    nix-index-database.hmModules.nix-index
    nixvim.homeManagerModules.nixvim
    sops-nix.homeManagerModules.sops
    spicetify-nix.homeManagerModules.default
    stylix.homeManagerModules.stylix
    wayland-pipewire-idle-inhibit.homeModules.default
  ];
}
