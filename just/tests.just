# Runs tests
run *args:
  nix run .#nixtests:run -- \
  --snapshot-dir {{justfile_directory()}}/nix/tests/_snapshots \
  {{args}}

# Updates test snapshots
updatesnaps: (run '--update-snapshots')
