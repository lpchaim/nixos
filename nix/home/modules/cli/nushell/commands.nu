# Wrapper for git branch
def "from git branches" []: list<string> -> list<string> {
    lines
    | each {
        str trim
        | str replace --regex '^\* ' ""
    }
}

# More nu-friendly fzf wrapper
def --wrapped fzf [
  path: cell-path,
  ...rest: string@__fzf_completions,
]: list -> list {
  let picked = $in
    | get $path
    | to text
    | ^fzf ...$rest
    | lines
  $in
    | where { |$it| ($it | get $path) in $picked }
}

def __fzf_completions [] {
  ^carapace fzf nushell fzf '--' | from json
}

# Cast to list, for e.g. ranges
def "into list" []: any -> list<any> {
    each {}
}
