# Enroll security key
enroll:
  #!/usr/bin/env bash
  mkdir -p ~/.config/Yubico
  [ -e ~/.config/Yubico/u2f_keys ] \
      && pamu2fcfg \
          --origin="pam://localhost" \
          --appid="pam://auth" \
          --nouser \
          >> ~/.config/Yubico/u2f_keys \
      || pamu2fcfg \
          --origin="pam://localhost" \
          --appid="pam://auth" \
          > ~/.config/Yubico/u2f_keys

# Clear enrolled security keys, if any
clear:
  [ -e ~/.config/Yubico/u2f_keys ] \
      && rm -f ~/.config/Yubico/u2f_keys
