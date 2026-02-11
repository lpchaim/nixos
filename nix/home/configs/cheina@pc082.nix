{
  config,
  lib,
  pkgs,
  ...
}: {
  home = {
    username = "cheina";
    homeDirectory = "/home/cheina";
    stateVersion = "23.05";
  };

  my = {
    ci.build = true;
    cli.enable = true;
    cli.git.enable = true;
    cli.hishtory.enable = false;
    de.gnome.theming.enableGnomeShellTheme = false;
    development.nixd.enableLsp = false;
    profiles = {
      standalone = true;
      wayland = true;
    };
  };

  home.sessionVariables.XDEBUG_MODE = "off";

  home.packages = [
    (pkgs.writeShellScriptBin "dev2beta" ''
      git checkout dev && git pull && git checkout beta && git pull
      git branch -D bugfix#dev2beta >/dev/null 2>&1
      git checkout -b bugfix#dev2beta && git merge dev --no-ff --no-edit
    '')
    (pkgs.writeShellScriptBin "dev2master" ''
      git checkout dev && git pull && git checkout master && git pull
      git branch -D hotfix#dev2master >/dev/null 2>&1
      git checkout -b hotfix#dev2master && git merge dev --no-ff --no-edit
    '')
    (pkgs.writeShellScriptBin "master2dev" ''
      git checkout master && git pull && git checkout dev && git pull
      git branch -D bugfix#master2dev >/dev/null 2>&1
      git checkout -b bugfix#master2dev && git merge master --no-ff --no-edit
    '')
    (pkgs.writeShellScriptBin "cleanslate" ''
      git fetch origin dev:dev && git checkout dev
    '')
  ];

  programs = {
    atuin.daemon.enable = false;
    helix.languages.language = [
      {
        name = "php";
        language-id = "php";
        debugger = {
          name = "vscode-php-debug";
          transport = "stdio";
          command = "node";
          args = ["~/.vscode/extensions/xdebug.php-debug-1.34.0/out/phpDebug.js"];
        };
        debugger.templates = [
          {
            name = "Listen for Xdebug";
            request = "launch";
            completion = ["ignored"];
            args = {};
          }
        ];
      }
    ];
    tmux.extraConfig = lib.optionalString config.programs.nushell.enable ''
      set-option -g default-shell ${config.programs.nushell.package}/bin/nu
    '';
    zsh.initContent = ''
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
      export PATH="$PATH:$HOME/Lucas/Bin";
    '';
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      enable-hot-corners = true;
    };
    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = [];
      switch-applications-backward = [];
      switch-windows = ["<Alt>Tab"];
      switch-windows-backward = ["<Shift><Alt>Tab"];
    };
  };
}
