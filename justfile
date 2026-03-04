_default:
  just --list --list-submodules --unsorted

mod home './just/home.just'
mod secrets './just/secrets.just'
mod secureboot './just/secureboot.just'
mod system './just/system.just'
mod theme './just/theme.just'
mod tests './just/tests.just'
mod u2f './just/u2f.just'

# Run tests
test *args: (tests::run args)
