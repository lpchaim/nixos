# Updates secret files, run after adding new keys
update:
  #!/usr/bin/env zsh
  sops updatekeys secrets/**/*

# Opens a secrets file for editing
@edit file='secrets/default.yaml':
  sops {{ file }}

# Grabs a host's SSH key and generates the corresponding age key
@get-host-key host:
  nix shell nixpkgs#ssh-to-age nixpkgs#openssh \
  --command ssh-keyscan localhost 2>/dev/null \
  | ssh-to-age 2>/dev/null
