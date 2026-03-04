set working-directory := '../'

# Runs tests
run *args:
  nix run .#nixtests:run -- \
  --snapshot-dir ./nix/tests/_snapshots \
  {{args}}

# Updates test snapshots
updatesnaps: (run '--update-snapshots')
