_default:
  @just --list --list-submodules --unsorted

mod generate './just/generate.just'
mod secrets './just/secrets.just'
mod secureboot './just/secureboot.just'
mod theme './just/theme.just'
mod u2f './just/u2f.just'
mod unittests './just/unittests.just'

# Run checks
check:
  nix flake check --quiet --all-systems

# Run tests
test *args: (unittests::run args)
