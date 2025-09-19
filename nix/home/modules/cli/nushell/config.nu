$env.config = {
  show_banner: false # true or false to enable or disable the welcome banner at startup
  edit_mode: vi # emacs, vi
  use_kitty_protocol: true # enables keyboard enhancement protocol implemented by kitty console, only if your terminal support this

  table: {
      mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
      index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
      show_empty: true # show 'empty list' and 'empty record' placeholders for command output
  }

  history: {
      max_size: 100_000 # Session has to be reloaded for this to take effect
      sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
      file_format: "plaintext" # "sqlite" or "plaintext"
      isolation: false # only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
  }

  completions: {
      case_sensitive: false # set to true to enable case-sensitive completions
      quick: true    # set this to false to prevent auto-selecting completions when only one remains
      partial: true    # set this to false to prevent partial filling of the prompt
      algorithm: "fuzzy"    # prefix or fuzzy
      external: {
          enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up may be very slow
          max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
          # completer: null # check 'carapace_completer' above as an example
      }
  }

  cursor_shape: {
      emacs: line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (line is the default)
      vi_insert: line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (block is the default)
      vi_normal: block # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (underscore is the default)
  }

  keybindings: [
      {
          name: open_command_editor
          modifier: alt
          keycode: char_e
          mode: [emacs, vi_normal, vi_insert]
          event: { send: openeditor }
      }
  ]
}
