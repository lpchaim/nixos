# Generates the necessary keys in /etc/secureboot
create-keys:
  sudo sbctl create-keys

# Enrolls keys, requires system to be in setup mode
enroll-keys: create-keys
  sudo sbctl enroll-keys --microsoft
