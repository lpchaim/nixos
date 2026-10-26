args: {
  imports = [
    ./ci.nix
  ];

  perSystem = {pkgs, ...}: {
    apps = {
      update-tailscale-vars = {
        meta.description = "Updates tailscale IP addresses";
        program =
          pkgs.writers.writeNuBin "update-tailscale-vars"
          # nu
          ''
            let status = tailscale status --json | from json
            $status
              | get Peer
              | values
              | append $status.Self
              | each {
                [
                  ($in.DNSName | split row "." | first)
                  {
                    ip: {
                      v4: ($in.TailscaleIPs | first),
                      v6: ($in.TailscaleIPs | last),
                    }
                    tags: ($in | get --optional Tags | default [] | each { str replace --regex "^tag:" "" })
                  }
                ]
              }
              | into record
              | sort --natural --ignore-case
              | to json --raw
              | nix eval --expr $"builtins.fromJSON '''($in)'''"
              | alejandra --quiet
              | tee { save --force vars/networks/tailscale-nodes.nix }
          '';
      };
    };
  };
}
