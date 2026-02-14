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

# Nushell-friendly fzf wrapper
# 
# Supports plain lists and tables with optional cell path
def --wrapped fzf [
  --path: cell-path, # The cell path to use for the description
  ...rest: string@__fzf_completions,
]: list -> list {
  let input = $in;
  let hasPath = $path != null
  let isRecord = ($input | first | describe --detailed | get type) == "record"
  $input
    | if ($isRecord and not $hasPath) {
      enumerate
      | each { |it| {...$it.item, index: $it.index} }
      | to tsv
      | ^fzf --with-nth 1..-2 --delimiter "\t" --header-lines 1 ...$rest
    } else {
      each { if ($path != null) { get $path } else { $in } | to nuon }
      | enumerate
      | each { $"($in.item)\t($in.index)" }
      | to text
      | ^fzf --with-nth 1..-2 --delimiter "\t" ...$rest
    }
    | lines
    | each { split row "\t" | last | into int }
    | each { |index| $input | get $index }
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
