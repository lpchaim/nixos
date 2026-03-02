{
  perSystem = {pkgs, ...}: {
    apps.docker-lock = {
      meta.description = "Extracts digests from docker containers";
      program =
        pkgs.writeNuScriptStdinBin "docker-lock"
        # nu
        ''
          # Generates composer.override.yaml based on running containers
          #
          # As seen on https://github.com/docker/compose/issues/12836#issuecomment-2887147815
          def main [
            output: path = ./composer.override.yaml # Override file to create/update
            --update-existing = true # Merge the generated digests with the existing file
          ]: nothing -> nothing {
            sudo docker compose config --lock-image-digests
              | from yaml
              | if ($update_existing and ($output | path exists)) {
                open $output --raw
                | from yaml
                | deep merge $in
              } else { $in }
              | to yaml
              | save --force $output
          }
        '';
    };
  };
}
