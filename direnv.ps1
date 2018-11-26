# Install with:
#
#   new-item -itemtype file -path $profile -force
#   cp direnv.ps1 $profile
#
#   # maybe
#   Set-ExecutionPolicy RemoteSigned
#
#

# Run before the prompt
function Direnv-Hook {
  $diff = & direnv export json | ConvertFrom-Json

  # No output, return
  if (!$diff) {
    return
  }

  # Apply the diff
  $diff.psobject.properties | ForEach {
    $o = $_
    if ($o.Value -Or $o.Value -eq "") {
      #Write-Output "Setting $($o.Name) to $($o.Value)"
      Set-Item -path "Env:$($o.Name)" -value $o.Value
    } else {
      #Write-Output "Deleting $($o.Name)"
      Remove-Item -path "Env:$($o.Name)"
    }
  }
}

Rename-Item -Path Function:Global:prompt -NewName Direnv-Prompt-Backup

function Global:prompt {
  Direnv-Hook
  return Direnv-Prompt-Backup
}
