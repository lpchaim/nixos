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

  my.profiles = {
    formfactor.desktop = true;
    de.gnome = true;
    de.hyprland = true;
    hardware.gpu.nvidia = true;
    hardware.rgb = true;
  };
  my.gaming.enable = true;
  my.networking.tailscale.trusted = true;
  my.security.secureboot.enable = false;

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

<details open>
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
│   │   ├───generate-assets: app: Creates README.md assets
│   │   ├───generate-ci-matrix: app: Generates a GitHub Actions build matrix
│   │   └───render-readme: app: Renders README.md
│   └───x86_64-linux
│       ├───generate-assets: app: Creates README.md assets
│       ├───generate-ci-matrix: app: Generates a GitHub Actions build matrix
│       └───render-readme: app: Renders README.md
├───checks
│   ├───aarch64-linux
│   │   ├───deploy-shell: derivation 'nix-shell'
│   │   ├───minimal-shell: derivation 'nix-shell'
│   │   ├───nix-shell: derivation 'nix-shell'
│   │   ├───pre-commit: derivation 'pre-commit-run'
│   │   └───rust-shell: derivation 'nix-shell'
│   └───x86_64-linux
│       ├───deploy-shell: derivation 'nix-shell'
│       ├───minimal-shell: derivation 'nix-shell'
│       ├───nix-shell: derivation 'nix-shell'
│       ├───pre-commit: derivation 'pre-commit-run'
│       └───rust-shell: derivation 'nix-shell'
├───darwinConfigurations: unknown
├───darwinModules: unknown
├───devShells
│   ├───aarch64-linux
│   │   ├───default: development environment 'nix-shell'
│   │   ├───deploy: development environment 'deploy-shell'
│   │   ├───minimal: development environment 'minimal-shell'
│   │   ├───nix: development environment 'nix-shell'
│   │   └───rust: development environment 'rust-shell'
│   └───x86_64-linux
│       ├───default: development environment 'nix-shell'
│       ├───deploy: development environment 'deploy-shell'
│       ├───minimal: development environment 'minimal-shell'
│       ├───nix: development environment 'nix-shell'
│       └───rust: development environment 'rust-shell'
├───formatter
│   ├───aarch64-linux: package 'alejandra-4.0.0'
│   └───x86_64-linux: package 'alejandra-4.0.0'
├───homeConfigurations: unknown
├───homeModules: unknown
├───legacyPackages
│   ├───aarch64-linux omitted (use '--legacy' to show)
│   └───x86_64-linux omitted (use '--legacy' to show)
├───lib: unknown
├───nixosConfigurations
│   ├───desktop: NixOS configuration
│   ├───laptop: NixOS configuration
│   ├───raspberrypi: NixOS configuration
│   └───steamdeck: NixOS configuration
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
│   ├───nixpkgsVersions: Nixpkgs overlay
│   ├───nuInterpreterStdin: Nixpkgs overlay
│   └───python: Nixpkgs overlay
├───packages
│   ├───aarch64-linux
│   │   └───lichen: package 'lichen-0.22.0-unstable'
│   └───x86_64-linux
│       └───lichen: package 'lichen-0.22.0-unstable'
└───schemas: unknown
```
</details>
