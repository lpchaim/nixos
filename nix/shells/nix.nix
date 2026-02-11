{
  perSystem = {pkgs, ...}: {
    make-shells.nix = {
      additionalArguments.meta.description = "Nix development environment";
      additionalArguments.passthru.my.ci.buildFor = ["x86_64-linux"];
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
