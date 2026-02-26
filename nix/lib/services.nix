{lib, ...}: {
  mkOneShotBootService =
    lib.recursiveUpdate
    {
      serviceConfig.Type = "oneshot";
      wantedBy = ["default.target"];
    };
  mkOneShotSleepService =
    lib.recursiveUpdate
    {
      unitConfig = {
        DefaultDependencies = "no";
        StopWhenUnneeded = "yes";
      };
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
      };
      before = ["sleep.target"];
      wantedBy = ["sleep.target"];
    };
}
