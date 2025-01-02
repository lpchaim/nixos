# Wrapper for git branch
def "from git branches" []: list<string> -> list<string> {
  lines
  | each {
    str trim
    | str replace --regex '^\* ' ''
  }
}

# Wrapper for fzf
def "into fzf" []: list<string> -> string {
  to text
  | ^@fzf@
}

# Wrapper for fzf with multiple selections
def "into fzf multi" []: list<string> -> list<string> {
  to text
  | ^@fzf@ --multi
  | lines
}

# Cast to list, for e.g. ranges
def "into list" []: any -> list<any> {
    each {}
}
