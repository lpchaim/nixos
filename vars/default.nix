args: {
  name.user = "lpchaim";
  name.full = "Luna Perroni";
  email.main = "lpchaim@proton.me";
  flake.path = "~/.config/nixos";
  repo = rec {
    main = github;
    github = "https://github.com/lpchaim/nixos";
    tangled = "https://tangled.org/lpchaim/nix";
  };
  shell = "fish";
  wallpaper = ../assets/wallpaper.jpg;
  profilePicture = ../assets/profile-picture.png;
  ssh = import ./ssh.nix args;
  hosts = import ./hosts.nix;
  nix = import ./nix.nix args;
  kb = import ./kb.nix;
}
