# Wrapper for git branch
def --wrapped "git branch" [
  ...rest: string@__git_branch_completions,
] {
  ^git branch ...$rest
  | lines
  | each {
      str trim
      | str replace --regex '^\* ' ""
  }
}

def __git_branch_completions [] {
  __get_completions git branch
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
  __get_completions fzf
}

# Cast to list, for e.g. ranges
def "into list" []: any -> list<any> {
    each {}
}

# Helper to generate completion functions
def __get_completions [
  command: string,
  ...context: string,
] {
  ^carapace $command nushell $command ...$context '-'
  | from json
}
