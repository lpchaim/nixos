args: let
  inherit ((import ../lib args).config) flake repo;
in {
  perSystem = {pkgs, ...}: {
    make-shells.deploy = {
      additionalArguments.meta.description = "Extra deployment utilities built-in";
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
      shellHook = ''
        export EDITOR=hx
        export NH_FLAKE="${flake.path}"
      '';
    };
  };
}
