{
  perSystem = {
    lib,
    pkgs,
    self',
    ...
  }: {
    checks.nixtests = pkgs.runCommandLocal "nixtests-run" {} ''
      ${lib.getExe self'.legacyPackages."nixtests:run"} \
      --snapshot-dir ${../tests/_snapshots} \
      > $out
    '';
  };
}
