{lib, ...}: {
  options.my.ci = {
    build = lib.mkEnableOption "building on CI pipeline";
    branches = lib.mkOption {
      description = "Branches to build for";
      type = with lib.types; listOf singleLineStr;
      default = ["main"];
    };
  };
}
