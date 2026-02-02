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
$sampleconfig
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
$filestructure
```
</details>

## Outputs

If you're curious, this is what the flake actually outputs right now.
Courtesy of [flake-schemas]' patches with my own lib/pkgs schemas on top.

<details>
<summary>Output of `nix flake show`</summary>

```sh
$outputs
```
</details>
