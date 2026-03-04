# Opens the current stylix color scheme in a browser
@inspect:
  xdg-open "$(readlink -f ~/.config/stylix/palette.html)" 2>&1 >/dev/null
