args@{ config, pkgs, lib, ... }:

with builtins;
with lib;
let
  namespace = [ "my" "modules" "cli" "tmux" ];
  cfg = lib.getAttrFromPath namespace config;
  defaultClipboard = "clipboard"; # clipboard, primary, secondary
  termBasic = "screen-256color";
  termFull = "xterm-256color";
in
{
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "tmux";
    theme = lib.mkOption {
      description = "Which theme to use.";
      type = types.enum [ "catppuccin" "tmux-powerline" ];
      default = "catppuccin";
    };
  };

  config = lib.mkIf cfg.enable ({
    home.sessionVariables.TERM = termFull;

    home.packages = with pkgs; [
      xsel
    ];

    programs = {
      fzf.enable = true;
      tmux = {
        enable = true;
        aggressiveResize = true;
        baseIndex = 1;
        clock24 = true;
        extraConfig = ''
          # General
          set -g default-terminal '${termBasic}'
          set -g detach-on-destroy off
          set -g renumber-windows on
          set -g set-clipboard on
          set -ga terminal-overrides ',${termFull}:Tc'

          # Visuals
          set-option -g status-position top

          # Keybinds
          bind-key -n -r C-h select-pane -LZ
          bind-key -n -r C-j select-pane -DZ
          bind-key -n -r C-k select-pane -UZ
          bind-key -n -r C-l select-pane -RZ

          bind-key -r h resize-pane -L
          bind-key -r j resize-pane -D
          bind-key -r k resize-pane -U
          bind-key -r l resize-pane -R

          bind-key -n M-k next-window
          bind-key -n M-j previous-window

          bind-key v split-window -h
          bind-key s split-window -v

          # Plugins
          bind-key Space thumbs-pick
        '';
        keyMode = "vi";
        mouse = true;
        newSession = true;
        shortcut = "Space";
        plugins = with pkgs.tmuxPlugins; [
          sensible
          better-mouse-mode
          tmux-fzf
          (mkTmuxPlugin {
            pluginName = "tmux-menus";
            version = "unstable-2023-10-20";
            rtpFilePath = "menus.tmux";
            src = pkgs.fetchFromGitHub {
              owner = "jaclu";
              repo = "tmux-menus";
              rev = "764ac9cd6bbad199e042419b8074eda18e9d8b2d";
              sha256 = "sha256-tPUUaMASG/DtqxyN2VwCKPivYZkwVKjIScI99k6CJv8=";
            };
          })
          {
            plugin = vim-tmux-navigator;
            extraConfig = ''
              # Smart pane switching with awareness of Vim splits.
              # See: https://github.com/christoomey/vim-tmux-navigator
              is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
                  | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
              bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
              bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
              bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
              bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
              tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
              if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
                  "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
              if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
                  "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

              bind-key -T copy-mode-vi 'C-h' select-pane -L
              bind-key -T copy-mode-vi 'C-j' select-pane -D
              bind-key -T copy-mode-vi 'C-k' select-pane -U
              bind-key -T copy-mode-vi 'C-l' select-pane -R
              bind-key -T copy-mode-vi 'C-\' select-pane -l
            '';
          }
          {
            plugin = yank;
            extraConfig = ''
              set -g @yank_action 'copy-pipe-and-cancel' # or 'copy-pipe'
              set -g @yank_selection '${defaultClipboard}'
              set -g @yank_selection_mouse '${defaultClipboard}'
            '';
          }
          {
            plugin = tmux-thumbs;
            extraConfig =
              let
                pasteCommand = "(echo {} | xsel --${defaultClipboard})"; # TODO OS-specific variants, check available tools
              in
              ''
                set -g @thumbs-command '${pasteCommand} && tmux set-buffer -- {} && tmux display-message \"Copied {}\"'
                set -g @thumbs-upcase-command '${pasteCommand} && tmux set-buffer -- {} && tmux paste-buffer && tmux display-message \"Copied {}\"'
                # set -g @thumbs-osc52 1
              '';
          }
          {
            plugin = resurrect;
            extraConfig =
              let
                simpleRestore = [ "btop" "htop" "nu" ];
                complexRestore = [ "hx" "nano" "nix-shell" "vim" ];
                resurrectProcesses = lib.concatStringsSep " " (
                  simpleRestore
                    ++ (map (x: "\"~${x}->${x} *\"") complexRestore)
                );
              in
              ''
                set -g @resurrect-strategy-vim 'session'
                set -g @resurrect-strategy-nvim 'session'
                set -g @resurrect-capture-pane-contents 'on'
                set -g @resurrect-processes '${resurrectProcesses}'
              '';
          }
          {
            plugin = continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
              set -g @continuum-boot 'on'
              set -g @continuum-save-interval '10'
            '';
          }
        ];
      };
    };
  } // lib.setAttrByPath namespace {
    catppuccin.enable = (cfg.theme == "catppuccin");
    tmux-powerline.enable = (cfg.theme == "tmux-powerline");
  });

  imports = [
    ./catppuccin/default.nix
    ./tmux-powerline/default.nix
  ];
}
