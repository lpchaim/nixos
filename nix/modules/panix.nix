{
  perSystem = {pkgs, ...}: let
    config = {
      flags = {
        activation_mode.pertype = {
          homeConfigurations = "switch";
          nixosConfigurations = "boot";
        };
        local_machine_hostname = "none";
        tags = ["default"];
      };
      fleet = {
        tags = ["production" "all"];
        auto_rollback = false;
        ssh = {
          username = "root";
          port = 22;
          disable_strict_key_checking = false;
        };
        activation_hooks = {
          pre = [''nix run nixpkgs#nvd -- diff /run/current-system "$PANIX_CLOSURE"''];
        };
        flakes.main.installables = {
          nixosConfigurations = {
            desktop = {
              tags = ["local" "personal" "default"];
              machines.desktop = {};
            };
            laptop = {
              tags = ["local" "personal"];
              machines.laptop = {};
            };
            raspberrypi = {
              tags = ["local" "server" "default"];
              machines.raspberrypi = {};
            };
          };
          homeConfigurations = {
            "lpchaim@steamdeck" = {
              tags = ["local" "personal"];
              ssh.username = "lpchaim";
              machines.steamdeck = {};
            };
          };
        };
      };
    };
    schema = pkgs.runCommandLocal "panix-yaml-schema" {buildInputs = [pkgs.panix];} ''
      panix schema --output $out --themes-output=/dev/null
    '';
  in {
    files.file."panix.yml".source =
      pkgs.writeText "panix-json" (builtins.toJSON config)
      |> (jsonFile:
        pkgs.runCommandLocal "panix-yml" {buildInputs = [pkgs.remarshal];} ''
          echo '# yaml-language-server: $schema=${schema}' > $out
          cat ${jsonFile} | remarshal --if json --of yaml >> $out
        '');
  };
}
