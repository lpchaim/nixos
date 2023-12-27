{
  description = "Personal NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nix-software-center.url = "github:vlinkz/nix-software-center";
    nur.url = "github:nix-community/NUR";
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs = { self, disko, flake-utils, nixpkgs, nur, snowfall-flake, ... }@inputs:
    let
      makePkgs = system: import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
        overlays = [
          snowfall-flake.overlays.default
        ];
      };
      makeOsConfig = system: modules:
        let
          pkgs = makePkgs (system);
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./traits/base.nix
            disko.nixosModules.disko
            nur.nixosModules.nur
          ] ++ modules;
          specialArgs = { inherit inputs pkgs system; };
        };
      commonDailyDriver = [
        ./traits/kernel-zen.nix
        ./traits/user-lpchaim.nix
        ./traits/wayland.nix
        ./traits/pipewire.nix
      ];
    in
    {
      nixosConfigurations = {
        laptop = makeOsConfig "x86_64-linux" (commonDailyDriver ++ [
          ./hardware/laptop/configuration.nix
          ./traits/gnome.nix
          ./traits/laptop.nix
          ./traits/gaming.nix
        ]);
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = makePkgs system;
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nil
            nixd
            nixpkgs-fmt
            pre-commit
            rustup
            rnix-lsp
          ];
          shellHook = ''
            pre-commit install
          '';
        };
      }
    );
}
