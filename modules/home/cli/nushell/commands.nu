# Wrapper for fzf
def "nufzf" [] {
  $in
  | to text
  | ^@fzf@
}

# Wrapper for git branch
def "nugit branch" [] {
  ^@git@ branch
  | lines
  | each {
    str trim
    | str replace --regex '^\* ' ''
  }
}
