# nu
''
  $env.config = {
      show_banner: false # true or false to enable or disable the welcome banner at startup

      ls: {
          use_ls_colors: true # use the LS_COLORS environment variable to colorize output
          clickable_links: true # enable or disable clickable links. Your terminal has to support links.
      }

      rm: {
          always_trash: false # always act as if -t was given. Can be overridden with -p
      }

      table: {
          mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
          index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
          show_empty: true # show 'empty list' and 'empty record' placeholders for command output
          padding: { left: 1, right: 1 } # a left right padding of each column in a table
          trim: {
              methodology: wrapping # wrapping or truncating
              wrapping_try_keep_words: true # A strategy used by the 'wrapping' methodology
              truncating_suffix: "..." # A suffix used by the 'truncating' methodology
          }
          header_on_separator: false # show header text on separator/border line
          # abbreviated_row_count: 10 # limit data rows from top and bottom after reaching a set point
      }

      error_style: "fancy" # "fancy" or "plain" for screen reader-friendly error messages

      # datetime_format determines what a datetime rendered in the shell would look like.
      # Behavior without this configuration point will be to "humanize" the datetime display,
      # showing something like "a day ago."
      datetime_format: {
          # normal: '%a, %d %b %Y %H:%M:%S %z'    # shows up in displays of variables or other datetime's outside of tables
          # table: '%m/%d/%y %I:%M:%S%p'          # generally shows up in tabular outputs such as ls. commenting this out will change it to the default human readable datetime format
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

      filesize: {
          metric: true # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows standard)
          format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, auto
      }

      cursor_shape: {
          emacs: line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (line is the default)
          vi_insert: line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (block is the default)
          vi_normal: block # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (underscore is the default)
      }

      edit_mode: vi # emacs, vi
      shell_integration: {
          # osc2 abbreviates the path if in the home_dir, sets the tab/window title, shows the running command in the tab/window title
          osc2: true
          # osc7 is a way to communicate the path to the terminal, this is helpful for spawning new tabs in the same directory
          osc7: true
          # osc8 is also implemented as the deprecated setting ls.show_clickable_links, it shows clickable links in ls output if your terminal supports it. show_clickable_links is deprecated in favor of osc8
          osc8: true
          # osc9_9 is from ConEmu and is starting to get wider support. It's similar to osc7 in that it communicates the path to the terminal
          osc9_9: false
          # osc133 is several escapes invented by Final Term which include the supported ones below.
          # 133;A - Mark prompt start
          # 133;B - Mark prompt end
          # 133;C - Mark pre-execution
          # 133;D;exit - Mark execution finished with exit code
          # This is used to enable terminals to know where the prompt is, the command is, where the command finishes, and where the output of the command is
          osc133: true
          # osc633 is closely related to osc133 but only exists in visual studio code (vscode) and supports their shell integration features
          # 633;A - Mark prompt start
          # 633;B - Mark prompt end
          # 633;C - Mark pre-execution
          # 633;D;exit - Mark execution finished with exit code
          # 633;E - NOT IMPLEMENTED - Explicitly set the command line with an optional nonce
          # 633;P;Cwd=<path> - Mark the current working directory and communicate it to the terminal
          # and also helps with the run recent menu in vscode
          osc633: true
          # reset_application_mode is escape \x1b[?1l and was added to help ssh work better
          reset_application_mode: true
      }
      render_right_prompt_on_last_line: false # true or false to enable or disable right prompt to be rendered on last line of the prompt.
      use_kitty_protocol: true # enables keyboard enhancement protocol implemented by kitty console, only if your terminal support this

      hooks: {
          pre_prompt: [{ null }] # run before the prompt is shown
          pre_execution: [{ null }] # run before the repl input is run
          env_change: {
              PWD: [{|before, after| null }] # run if the PWD environment is different since the last repl input
          }
          display_output: "if (term size).columns >= 100 { table -e } else { table }" # run to display the output of a pipeline
          command_not_found: { null } # return an error message when a command is not found
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
''
