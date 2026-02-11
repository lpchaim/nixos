{
  perSystem = {pkgs, ...}: {
    make-shells.nix = {
      additionalArguments.meta.description = "Nix development environment";
      additionalArguments.passthru.my.ci.x86_64-linux.build = true;
      packages = with pkgs; [
        age
        alejandra
        nil
        nixd
        nixpkgs-fmt
        sops
        ssh-to-age
      ];
    };
  };
}
