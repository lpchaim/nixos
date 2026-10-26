{currentSystem, ...}: final: prev: let
  flakePath = builtins.getEnv "FLAKE_PATH";
  common = {
    inherit currentSystem;
  };
in
  if (flakePath != "")
  then let
    self = builtins.getFlake flakePath;
    getPrime = output: fallback:
      if self.${output} ? ${currentSystem}
      then self.${output}.${currentSystem}
      else fallback;
    self' =
      self
      // {
        apps = getPrime "apps" {};
        checks = getPrime "checks" {};
        devShells = getPrime "devShells" {};
        formatter = getPrime "formatter" {};
        packages = getPrime "packages" [];
        legacyPackages = getPrime "legacyPackages" {};
      };
  in
    common
    // self
    // {
      inherit self self';
      inherit (final.pkgs) lib;
      inherit (final.self'.legacyPackages) pkgs;
    }
  else let
    nixpkgs = builtins.getFlake "nixpkgs";
  in
    common
    // {
      inherit (nixpkgs) lib;
      pkgs = import nixpkgs {
        system = currentSystem;
        allowUnfree = true;
      };
    }
