{inputs, ...}: {
  perSystem = {self', ...}: let
    inherit (inputs.self.lib.config) flake repo;
    inherit (self'.legacyPackages) pkgs;
  in {
    make-shells.deploy = {
      additionalArguments.meta.description = "Extra deployment utilities built-in";
      inputsFrom = [self'.devShells.nix];
      packages = with pkgs; [
        disko
        home-manager
        nh
        nixos-generators
        nixos-rebuild
        (writeShellScriptBin "flake-init" ''
          if [ ! -d "${flake.path}" ]; then
            mkdir -p "${flake.path}"
            git clone --branch develop '${repo.main}' "${flake.path}"
            echo "Repo checked out at ${flake.path}"
          else
            echo 'Repo exists, nothing to do'
          fi
        '')
      ];
    };
  };
}
