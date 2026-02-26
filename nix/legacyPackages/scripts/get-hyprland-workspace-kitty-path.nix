{pkgs, ...}:
pkgs.writeNuScriptStdinBin "get-hyprland-workspace-kitty-path"
# nu
''
  # Get last kitty path on current workspace
  def main []: nothing -> any {
    let currentWorkspace = hyprctl activeworkspace -j | from json
    let activeWindow = hyprctl activewindow -j | from json
    if ($activeWindow.workspace.id != $currentWorkspace.id) {
      return
    }

    let currentWindowPid = $activeWindow
      | get pid
    let lastTitle = hyprctl clients -j
      | from json
      | where { $in.class == 'kitty' and $in.pid != $currentWindowPid }
      | sort-by pid
      | last
      | get title
    [
      $currentWindowPid
      $lastTitle
    ]
  }
''
