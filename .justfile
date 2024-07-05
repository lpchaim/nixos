_default:
    just --list

[group("nixos")]
[doc("Runs nixos-rebuild switch")]
deploy flake='.#' target='localhost':
    sudo nixos-rebuild switch \
    --flake {{ flake }} \
    --target-host {{ target }}

[group("nixos")]
[doc("Runs nixos-rebuild test")]
test flake='.#':
    sudo nixos-rebuild test \
    --flake {{ flake }}

[group("secrets")]
[doc("Updates secret files, run after adding new keys")]
secrets-update:
    #!/usr/bin/env zsh
    sops updatekeys secrets/**/*

[group("secrets")]
[doc("Grabs a host's SSH key and generates the corresponding age key")]
@host-get-key host:
    nix shell nixpkgs#ssh-to-age nixpkgs#openssh \
    --command ssh-keyscan localhost 2>/dev/null \
    | ssh-to-age 2>/dev/null

[group("secrets")]
[doc("Opens a secrets file for editing")]
@secrets-edit file='secrets/default.yaml':
    sops {{ file }}

[group("theming")]
[doc("Opens the current stylix color scheme in a browser")]
@theme-inspect:
    firefox $(readlink -f /etc/stylix/palette.html)
