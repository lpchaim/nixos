{lib, ...}: {
  options.my.ci = {
    build = lib.mkEnableOption "building on CI pipeline";
  };
}
