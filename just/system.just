# Runs nixos-rebuild switch
switch flake='.#' target='localhost': (_rebuild 'switch' flake target)

# Runs nixos-rebuild build
build flake='.#': (_rebuild 'build' flake)

# Runs nixos-rebuild boot
boot flake='.#': (_rebuild 'boot' flake)

# Runs nixos-rebuild test
test flake='.#': (_rebuild 'test' flake)

_rebuild command flake='.#' target='localhost':
  sudo nixos-rebuild {{ command }} \
  --flake '{{ flake }}' \
  {{ if target != 'localhost' { '--target-host {{ target }}' } else { "" } }}
