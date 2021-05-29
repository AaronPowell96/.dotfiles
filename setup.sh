##############
### COLORS ###
##############
### Only use colors if connected to a terminal
    if [ -t 1 ]; then
        RED=$(printf '\u001b[31m')
        GREEN=$(printf '\u001b[32m')
        YELLOW=$(printf '\u001b[33m')
        BLUE=$(printf '\u001b[34m')
        MAGENTA=$(printf '\u001b[35m')
        CYAN=$(printf '\u001b[36m')
        WHITE=$(printf '\u001b[37m')
        BOLD=$(printf '\033[1m')
        RESET=$(printf '\033[m')
    else
        RED=""
        GREEN=""
        YELLOW=""
        BLUE=""
        MAGENTA=""
        CYAN=""
        WHITE=""
        BOLD=""
        RESET=""
    fi

command_exists() {
    command -v "$@" >/dev/null 2>&1
}

error() {
    printf -- "%sError: $*%s\n" >&2 "$RED" "$RESET"
}

### Center print text, "text" "text color" "line color"
center() {
  termwidth="$(tput cols)"
  padding="$(printf '%0.1s' ={1..500})"

  textColor="${2:-$WHITE}"
  lineColor="${3:-$textColor}"
  printf '\n%s%*.*s %s%s%s %*.*s\n' "$lineColor" 0 "$(((termwidth-2-${#1})/2))" "$padding" "$textColor" "$1" "$lineColor" 0 "$(((termwidth-1-${#1})/2))" "$padding" "$2"
}

check_directory() {
center "User: $(whoami)  |  Directory: $(pwd)" "$YELLOW" "$RED"

### Move directory to home directory if current directory doesn't end with username.
if [[ "$(pwd)" != "$HOME" ]]
then
    cd ~;
    center "Moved to $(pwd)" "$RED" "$RED"
fi
}

default_windows_settings() {
    center "Editing windows settings" "$YELLOW"
        powershell.exe -noprofile -executionpolicy bypass -file ~/.dotfiles/windows.ps1
}

download_chocolatey() {
center "Running Chocolatey Install" "$BLUE" "$BLUE"
# ### Chocolatey install
 powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
 PATH=%PATH%;%ALLUSERSPROFILE%/chocolatey/bin
}

download_fonts() {
center "Downloading fonts" "$WHITE" "$YELLOW"

center "Installing Fira-Code font" "$GREEN" "$GREEN"
    choco install firacode -fy

center "Installing Cascadia-Code font" "$GREEN" "$GREEN"
# ## Add cascadiacode font for windows terminal
    choco install cascadiacode -fy
}

setup_terminal() {
center "Setting up windows terminal" "$MAGENTA" "$MAGENTA"
center "Terminal: Installing Cascadia-Code font" "$MAGENTA" "$MAGENTA"
# ## Add cascadiacode font for windows terminal
 choco install cascadiacode -fy

center "Terminal: Installing Windows Terminal" "$MAGENTA" "$MAGENTA"
# ## Install Windows Terminal
 choco install microsoft-windows-terminal -fy

center "Terminal: Symlinking Windows Terminal Settings" "$MAGENTA" "$MAGENTA"
# ## Add a symlink for Windows Terminal settings.
 ln -sf ~/.dotfiles/windows-terminal-settings.json $LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json
 ln -sf ~/.dotfiles/windows-terminal-settings.json $LOCALAPPDATA/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json
}

download_packages() {
center "Downloading Applications" "$CYAN"
### Install all the packages
center "App: Installing Chrome" "$CYAN"
 choco install googlechrome -fy
center "App: Installing Firefox" "$CYAN"
 choco install firefox -fy
center "App: Installing VsCode" "$CYAN"
 choco install vscode -fy
center "App: Installing Postman" "$CYAN"
 choco install postman -fy
center "App: Installing Spotify" "$CYAN"
 choco install spotify -fy
### choco install <package_name> repeats for all the packages you want to install
}

### shellcheck source=/dev/null
setup_devtools() {
    center "Setting up development tools" "$YELLOW"

    command_exists git || {
        error "git is not installed"
        exit 1
    }

    center "Dev Tool: Installing Node Version Manager" "$YELLOW"
     choco install nvm -fy

    center "Dev Tool: Installing Node.js" "$YELLOW"
     nvm install latest

    center "Dev Tool: Installing Python" "$YELLOW"
     choco install python -fy

    center "Dev Tool: Installing Java JDK 11" "$YELLOW"
     choco install jdk11 -fy

    center "Dev Tool: Installing Yarn" "$YELLOW"
     choco install yarn -fy

    center "Dev Tool: Installing VirtualBox" "$YELLOW"
     choco install virtualbox -fy
}

setup_dotfiles(){
center "Dotfile: Symlinking settings" "$GREEN"
# ## Symlink dot files.
center "Linking .bashrc" "$GREEN"
 ln -sf ~/.dotfiles/.bashrc ~/.bashrc
center "Linking .bash_profile" "$GREEN"
 ln -sf ~/.dotfiles/.bash_profile ~/.bash_profile
center "Linking .gitconfig" "$GREEN"
 ln -sf ~/.dotfiles/.gitconfig ~/.gitconfig
center "Linking .vscode" "$GREEN"
 ln -sf ~/.dotfiles/.vscode $(pwd)/.vscode
center "Linking VSCode settings.json" "$GREEN"
 ln -sf ~/.dotfiles/.vscode/settings.json $APPDATA/Code/User/settings.json
}

### Pin apps to taskbar and unpin edge. (Not sure how to unpin Windows Apps Store)
pin_to_taskbar(){
    center "Pinning Applications to taskbar" "$MAGENTA"
    powershell -noprofile -ExecutionPolicy Bypass -file ./PinToTaskBar.ps1 "$APPDATA\Spotify\Spotify.exe" PIN
    powershell -noprofile -ExecutionPolicy Bypass -file ./PinToTaskBar.ps1 "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" PIN
    powershell -noprofile -ExecutionPolicy Bypass -file ./PinToTaskBar.ps1 "$LOCALAPPDATA/Programs/Microsoft VS Code/Code.exe" PIN
    powershell -noprofile -ExecutionPolicy Bypass -file ./PinToTaskBar.ps1 "$LOCALAPPDATA\Microsoft.WindowsTerminal_8wekyb3d8bbwe\wt.exe" PIN
    powershell -noprofile -ExecutionPolicy Bypass -file ./PinToTaskBar.ps1 "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" UNPIN
}

main() {
   check_directory
   default_windows_settings
   download_chocolatey
  
   command_exists choco || {
        error "choco is not installed"
        exit 1
    }
   download_fonts
   setup_terminal
   download_packages
   setup_devtools
   setup_dotfiles
   pin_to_taskbar
}

main