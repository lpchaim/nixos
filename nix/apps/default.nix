args: {
  imports = [
    ./assets.nix
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
            tailscale status --json
              | from json
              | get Peer
              | values
              | each {
                [
                  ($in.DNSName | split row "." | first)
                  {
                    ip: {
                      v4: ($in.TailscaleIPs | first),
                      v6: ($in.TailscaleIPs | last),
                    }
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
