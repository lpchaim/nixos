# Edit a secret
edit *args:
  agenix edit {{args}}

# View a secret
view *args:
  agenix view {{args}}

# Rekey secrets
rekey *args:
  agenix rekey {{args}}

# Get host keys
getkeys hostname='localhost':
  ssh-keyscan {{hostname}} 2>/dev/null \
  | grep --regexp "^[^#][^ ]* ssh-" \
  | sort
