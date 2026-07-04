set working-directory := '../'

# Runs tests
run *args:
  @nix run .#nixtests:run -- \
  --snapshot-dir ./nix/tests/_snapshots \
  {{args}} \
  | sed -e 's|✅| |' -e 's|❌| |'

# Updates test snapshots
updatesnaps: (run '--update-snapshots')
