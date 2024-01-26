{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nodePackages.clipboard-cli
  ];

  programs.zsh.initExtra = ''
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    export PATH="$PATH:$HOME/Lucas/Bin";

    dev2beta() {
    	git checkout dev && git pull && git checkout beta && git pull
    	git branch -D bugfix#dev2beta >/dev/null 2>&1
    	git checkout -b bugfix#dev2beta && git merge dev --no-ff --no-edit
    }
    dev2master() {
    	git checkout dev && git pull && git checkout master && git pull
    	git branch -D hotfix#dev2master >/dev/null 2>&1
    	git checkout -b hotfix#dev2master && git merge dev --no-ff --no-edit
    }
    master2dev() {
    	git checkout master && git pull && git checkout dev && git pull
    	git branch -D bugfix#master2dev >/dev/null 2>&1
    	git checkout -b bugfix#master2dev && git merge master --no-ff --no-edit
    }
    cleanslate() {
    	git fetch origin dev:dev && git checkout dev
    }
  '';

  my.modules = {
    enable = true;
    cli.enable = true;
    cli.git.enable = false;
    cli.hishtory.enable = false;
  };
}
