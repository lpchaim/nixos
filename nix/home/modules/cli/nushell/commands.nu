# Wrapper for git branch
@complete external
def --wrapped "git branch" [
  ...rest: string,
] {
  ^git branch ...$rest
  | lines
  | each {
      str trim
      | str replace --regex '^\* ' ""
  }
}

# Nushell-friendly fzf wrapper
# 
# Supports plain lists and tables with optional cell path
@complete external
def --wrapped fzf [
  --path: cell-path, # The cell path to use for the description
  ...rest: string,
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

# Cast to list, for e.g. ranges
def "into list" []: any -> list<any> {
    each {}
}
