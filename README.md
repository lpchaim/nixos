[caelestia]: https://github.com/caelestia-dots/shell
[ez-configs]: https://github.com/ehllie/ez-configs/
[flake-parts]: https://github.com/hercules-ci/flake-parts
[flake-schemas]: https://github.com/DeterminateSystems/flake-schemas
[haumea]: https://github.com/nix-community/haumea
[rofi]: https://github.com/davatorium/rofi
[stylix]: https://github.com/danth/stylix

<p align="center">
    <i href="https://github.com/lpchaim/nixos/actions/workflows/check.yml">
        <img src="https://github.com/lpchaim/nixos/actions/workflows/check.yml/badge.svg" title="Checks flake outputs"/>
    </i>
    <i href="https://github.com/lpchaim/nixos/actions/workflows/build.yml">
        <img src="https://github.com/lpchaim/nixos/actions/workflows/build.yml/badge.svg" title="Builds flake outputs"/>
    </i>
</p>

<p align="center">
    <img src="assets/readme/screenshot.png" title="Screenshot of my desktop with fasfetch on top"/>
</p>

---

Welcome to my NixOS flake! It's mostly powered by [flake-parts], with some [haumea] sprinkled in for painless module loading here and there.

This is mainly for my NixOS configurations, but it also has a couple standalone Home Manager configs, development shells and NixOS/Home Manager modules.

## Design goals

- Simple, easy to parse and short system/home configurations
    - Minimal boilerplate
    - Largely orthogonal `profiles` instead of one-off module options, e.g. enable `my.profiles.gaming = true` instead of specifying several options per host
- Good separation of concerns and modularity, I dislike how monolithic flakes tend to turn out
    - Huge shoutout to [flake-parts] for helping with this!
- No libraries with too much magic behind how they work
  - As little obfuscation as possible on how things work, compose my own tools from more barebones ones as needed

I use [ez-configs] to get some boilerplate out of the way when it comes to setting up systems and home configurations. I usually define home configurations directly on the system configurations themselves since they tend to have similar functionality goals and complimentary options anyway.

I have plenty of custom HM and NixOS modules, so I use `profiles` to group them together and massively simplify my configs. They also have enough smarts to, for instance, enable the `gnome` Home Manager module by default if the host system has the same module enabled.

As an example, this is a working NixOS configuration describing my main rig.

```nix
{inputs, ...}: let
  inherit (inputs.self.lib.config) name;
in {
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
  ];

  my = {
    gaming.enable = true;
    networking.tailscale.trusted = true;
    profiles = {
      formfactor.desktop = true;
      hardware.gpu.nvidia = true;
      hardware.rgb = true;
      de.gnome = true;
      de.hyprland = true;
    };
  };

  networking.interfaces.enp6s0.wakeOnLan.enable = true;

  system.stateVersion = "23.11";
  home-manager.users.${name.user}.home.stateVersion = "24.11";
}
```

## Look and feel

I daily drive Hyprland with [caelestia] and [rofi].

My systems wouldn't look even halfway as good without [stylix] doing all the heavy-lifting in my stead.
The color scheme used in my screenshots is `stella`.

## File structure

I'm hoping the file structure under `/nix` is mostly self-explanatory. That said, there are a couple that bear explaining:
- `modules` for flake modules consumed by [flake-parts]
- `schemas` for my custom [flake-schemas] definitions
- `shared` for configuration and modules useful to both and NixOS and Home Manager

<details>
<summary>Tree view of the directory structure</summary>

```sh
./nix
├── apps
│   ├── assets.nix
│   ├── ci.nix
│   └── default.nix
├── home
│   ├── configs
│   └── modules
├── lib
│   ├── config.nix
│   ├── default.nix
│   ├── loaders.nix
│   ├── storage
│   └── strings.nix
├── modules
│   ├── default.nix
│   ├── ezConfigs.nix
│   ├── gitHooks.nix
│   └── just.nix
├── nixos
│   ├── configs
│   └── modules
├── overlays
│   ├── default.nix
│   ├── lix.nix
│   ├── nixpkgsVersions.nix
│   ├── nuInterpreterStdin.nix
│   └── python.nix
├── packages
│   ├── default.nix
│   └── lichen
├── schemas
│   ├── default.nix
│   ├── lib.nix
│   └── pkgs.nix
├── scripts
│   ├── default.nix
│   ├── lastdl.nix
│   ├── leastspaces.nix
│   ├── nu-generate-carapace-spec.nix
│   ├── nu-generate-manpage.nix
│   ├── nu-inspect.nix
│   └── nu-parse-help.nix
├── shared
│   ├── default.nix
│   └── theming.nix
└── shells
    ├── default.nix
    ├── deploy.nix
    ├── minimal.nix
    ├── nix.nix
    └── rust.nix
```
</details>

## Outputs

If you're curious, this is what the flake actually outputs right now.
Courtesy of [flake-schemas]' patches with my own lib/pkgs schemas on top.

<details>
<summary>Output of `nix flake show`</summary>

```sh
git+file:///home/lpchaim/.config/nixos
├───apps
│   ├───aarch64-linux
│   │   ├───generate-assets: app
│   │   ├───generate-ci-matrix: app
│   │   └───render-readme: app
│   └───x86_64-linux
│       ├───generate-assets: app
│       ├───generate-ci-matrix: app
│       └───render-readme: app
├───checks
│   ├───aarch64-linux
│   │   ├───deploy-shell: CI test [nix-shell]
│   │   ├───minimal-shell: CI test [nix-shell]
│   │   ├───nix-shell: CI test [nix-shell]
│   │   ├───pre-commit: CI test [pre-commit-run]
│   │   └───rust-shell: CI test [nix-shell]
│   └───x86_64-linux
│       ├───deploy-shell: CI test [nix-shell]
│       ├───minimal-shell: CI test [nix-shell]
│       ├───nix-shell: CI test [nix-shell]
│       ├───pre-commit: CI test [pre-commit-run]
│       └───rust-shell: CI test [nix-shell]
├───darwinConfigurations
├───darwinModules
├───devShells
│   ├───aarch64-linux
│   │   ├───default: development environment [nix-shell]
│   │   ├───deploy: development environment [deploy-shell]
│   │   ├───minimal: development environment [minimal-shell]
│   │   ├───nix: development environment [nix-shell]
│   │   └───rust: development environment [rust-shell]
│   └───x86_64-linux
│       ├───default: development environment [nix-shell]
│       ├───deploy: development environment [deploy-shell]
│       ├───minimal: development environment [minimal-shell]
│       ├───nix: development environment [nix-shell]
│       └───rust: development environment [rust-shell]
├───formatter
│   ├───aarch64-linux: formatter [alejandra-4.0.0]
│   └───x86_64-linux: formatter [alejandra-4.0.0]
├───homeConfigurations
│   ├───"cheina@pc082": Home Manager configuration [home-manager-generation]
│   ├───"lpchaim@desktop": Home Manager configuration [home-manager-generation]
│   ├───"lpchaim@laptop": Home Manager configuration [home-manager-generation]
│   ├───"lpchaim@raspberrypi": Home Manager configuration [home-manager-generation]
│   └───"lpchaim@steamdeck": Home Manager configuration [home-manager-generation]
├───homeModules
│   ├───bars: Home Manager module
│   ├───cli: Home Manager module
│   ├───de: Home Manager module
│   ├───default: Home Manager module
│   ├───gui: Home Manager module
│   ├───misc: Home Manager module
│   ├───nix: Home Manager module
│   ├───profiles: Home Manager module
│   ├───scripts: Home Manager module
│   ├───security: Home Manager module
│   ├───syncthing: Home Manager module
│   └───theming: Home Manager module
├───legacyPackages
│   └───(skipped; use '--legacy' to show)
├───lib
│   ├───config
│   │   ├───email
│   │   │   └───main: configuration constant
│   │   ├───flake
│   │   │   └───path: configuration constant
│   │   ├───kb
│   │   │   ├───br
│   │   │   │   ├───layout: configuration constant
│   │   │   │   ├───options: configuration constant
│   │   │   │   └───variant: configuration constant
│   │   │   ├───default
│   │   │   │   ├───layout: configuration constant
│   │   │   │   ├───options: configuration constant
│   │   │   │   └───variant: configuration constant
│   │   │   └───us
│   │   │       ├───layout: configuration constant
│   │   │       ├───options: configuration constant
│   │   │       └───variant: configuration constant
│   │   ├───name
│   │   │   ├───full: configuration constant
│   │   │   └───user: configuration constant
│   │   ├───nix
│   │   │   ├───pkgs
│   │   │   │   └───config
│   │   │   │       ├───allowUnfree: configuration constant
│   │   │   │       └───permittedInsecurePackages: configuration constant
│   │   │   └───settings
│   │   │       ├───accept-flake-config: configuration constant
│   │   │       ├───auto-optimise-store: configuration constant
│   │   │       ├───builders-use-substitutes: configuration constant
│   │   │       ├───extra-experimental-features: configuration constant
│   │   │       ├───extra-substituters: configuration constant
│   │   │       ├───extra-trusted-public-keys: configuration constant
│   │   │       ├───keep-derivations: configuration constant
│   │   │       ├───keep-outputs: configuration constant
│   │   │       └───max-jobs: configuration constant
│   │   ├───profilePicture: configuration constant
│   │   ├───repo
│   │   │   └───main: configuration constant
│   │   ├───shell: configuration constant
│   │   └───wallpaper: configuration constant
│   ├───isNvidia: library function
│   ├───loaders
│   │   ├───callPackageDefault: library function
│   │   ├───callPackageNonDefault: library function
│   │   ├───importDefault: library function
│   │   ├───importNonDefault: library function
│   │   ├───list: library function
│   │   ├───listDefault: library function
│   │   ├───listDefaultRecursive: library function
│   │   ├───listNonDefault: library function
│   │   ├───listNonDefaultRecursive: library function
│   │   ├───load: library function
│   │   ├───loadDefault: library function
│   │   ├───loadNonDefault: library function
│   │   └───read: library function
│   ├───mkPkgs: library function
│   ├───storage
│   │   ├───btrfs
│   │   │   ├───mkSecondaryStorage: library function
│   │   │   └───mkStorage: library function
│   │   ├───mkSafePath: library function
│   │   └───ntfs
│   │       └───mkSecondaryStorage: library function
│   └───strings
│       └───replaceUsing: library function
├───nixosConfigurations
│   ├───desktop: NixOS configuration [nixos-system-desktop-26.05.20260126.bfc1b8a]
│   ├───laptop: NixOS configuration [nixos-system-laptop-26.05.20260126.bfc1b8a]
│   ├───raspberrypi: NixOS configuration [nixos-system-raspberrypi-26.05.20260126.bfc1b8a]
│   └───steamdeck: NixOS configuration [nixos-system-steamdeck-26.05.20260126.bfc1b8a]
├───nixosModules
│   ├───boot: NixOS module
│   ├───default: NixOS module
│   ├───desktop: NixOS module
│   ├───gaming: NixOS module
│   ├───hardware: NixOS module
│   ├───kdeconnect: NixOS module
│   ├───locale: NixOS module
│   ├───networking: NixOS module
│   ├───nix: NixOS module
│   ├───profiles: NixOS module
│   ├───programs: NixOS module
│   ├───secrets: NixOS module
│   ├───secureboot: NixOS module
│   ├───security: NixOS module
│   ├───services: NixOS module
│   ├───ssh: NixOS module
│   ├───steamos: NixOS module
│   ├───syncthing: NixOS module
│   ├───tailscale: NixOS module
│   ├───theming: NixOS module
│   └───zram: NixOS module
├───overlays
│   ├───external: Nixpkgs overlay
│   ├───lix: Nixpkgs overlay
│   ├───nixpkgsVersions: Nixpkgs overlay
│   ├───nuInterpreterStdin: Nixpkgs overlay
│   └───python: Nixpkgs overlay
├───packages
│   ├───aarch64-linux
│   │   └───lichen: package [lichen-0.22.0-unstable]
│   └───x86_64-linux
│       └───lichen: package [lichen-0.22.0-unstable]
└───schemas
    ├───apps: flake schema
    ├───bundlers: flake schema
    ├───checks: flake schema
    ├───darwinConfigurations: flake schema
    ├───darwinModules: flake schema
    ├───devShells: flake schema
    ├───dockerImages: flake schema
    ├───formatter: flake schema
    ├───homeConfigurations: flake schema
    ├───homeModules: flake schema
    ├───hydraJobs: flake schema
    ├───legacyPackages: flake schema
    ├───lib: flake schema
    ├───nixosConfigurations: flake schema
    ├───nixosModules: flake schema
    ├───overlays: flake schema
    ├───packages: flake schema
    ├───pkgs: flake schema
    ├───schemas: flake schema
    └───templates: flake schema
```
</details>
