# just
''
  _default:
      just --list

  # Runs nixos-rebuild switch
  [group("nixos")]
  deploy flake='.#' target='localhost':
      sudo nixos-rebuild switch \
      --flake {{ flake }} \
      {{ if target != 'localhost' { '--target-host {{ target }}' } else { "" } }}

  # Runs nixos-rebuild test
  [group("nixos")]
  test flake='.#':
      sudo nixos-rebuild test \
      --flake {{ flake }}

  # Updates secret files, run after adding new keys
  [group("secrets")]
  [group("security")]
  update-secrets:
      #!/usr/bin/env zsh
      sops updatekeys secrets/**/*

  # Grabs a host's SSH key and generates the corresponding age key
  [group("secrets")]
  [group("security")]
  @get-host-key host:
      nix shell nixpkgs#ssh-to-age nixpkgs#openssh \
      --command ssh-keyscan localhost 2>/dev/null \
      | ssh-to-age 2>/dev/null

  # Opens a secrets file for editing
  [group("secrets")]
  [group("security")]
  @edit-secrets file='secrets/default.yaml':
      sops {{ file }}

  # Enroll security key
  [group("security")]
  enroll-security-key:
      #!/usr/bin/env bash
      mkdir -p ~/.config/Yubico
      [ -e ~/.config/Yubico/u2f_keys ] \
          && pamu2fcfg \
              --origin="pam://localhost" \
              --appid="pam://auth" \
              --nouser \
              >> ~/.config/Yubico/u2f_keys \
          || pamu2fcfg \
              --origin="pam://localhost" \
              --appid="pam://auth" \
              > ~/.config/Yubico/u2f_keys

  # Clear enrolled security keys, if any
  [group("security")]
  clear-security-keys:
      [ -e ~/.config/Yubico/u2f_keys ] \
          && rm -f ~/.config/Yubico/u2f_keys

  # Generates the necessary keys in /etc/secureboot
  [group("secureboot")]
  [group("security")]
  create-secureboot-keys:
      sudo sbctl create-keys

  # Enrolls keys, requires system to be in setup mode
  [group("secureboot")]
  [group("security")]
  enroll-secureboot-keys: create-secureboot-keys
      sudo sbctl enroll-keys --microsoft

  # Opens the current stylix color scheme in a browser
  [group("theming")]
  @inspect-theme:
      firefox $(readlink -f /etc/stylix/palette.html)
''
