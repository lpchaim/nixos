# Runs home-manager switch
switch flake='.#': (_hm 'switch' flake)

# Runs home-manager build
build flake='.#': (_hm 'build' flake)

_hm command flake='.#':
  home-manager {{ command }} \
  --flake '{{ flake }}' \
  -b backup
