# powershell -noprofile -ExecutionPolicy Bypass -file ./PinToTaskBar.ps1 "$APPDATA\Spotify\Spotify.exe" PIN
# powershell -noprofile -ExecutionPolicy Bypass -file ./PinToTaskBar.ps1 "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" PIN
# powershell -noprofile -ExecutionPolicy Bypass -file ./PinToTaskBar.ps1 "$LOCALAPPDATA/Programs/Microsoft VS Code/Code.exe" PIN
# powershell -noprofile -ExecutionPolicy Bypass -file ./PinToTaskBar.ps1 "$LOCALAPPDATA\Microsoft.WindowsTerminal_8wekyb3d8bbwe\wt.exe" PIN
# powershell -noprofile -ExecutionPolicy Bypass -file ./PinToTaskBar.ps1 "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" UNPIN

RED=$(printf '\u001b[31m')
        GREEN=$(printf '\u001b[32m')
        YELLOW=$(printf '\u001b[33m')
        BLUE=$(printf '\u001b[34m')
        MAGENTA=$(printf '\u001b[35m')
        CYAN=$(printf '\u001b[36m')
        WHITE=$(printf '\u001b[37m')
        BOLD=$(printf '\033[1m')
        RESET=$(printf '\033[m')
        
center() {
  termwidth="$(tput cols)"
  padding="$(printf '%0.1s' ={1..500})"

  textColor="${2:-$WHITE}"
  lineColor="${3:-$WHITE}"
  printf '\n%s%*.*s %s%s%s %*.*s\n' "$lineColor" 0 "$(((termwidth-2-${#1})/2))" "$padding" "$textColor" "$1" "$lineColor" 0 "$(((termwidth-1-${#1})/2))" "$padding" "$2"
}

printf "%s%s" "$YELLOW" "test"
center "test test test" "$WHITE"
echo 123