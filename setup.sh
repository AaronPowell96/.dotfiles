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

center() {
  termwidth="$(tput cols)"
  padding="$(printf '%0.1s' ={1..500})"
  printf '%*.*s %s%s%s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$2" "$1" "$RESET" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}

check_directory() {
center "User: $(whoami)  |  Directory: $(pwd)" "$BOLD"

### Move directory to home directory if current directory doesn't end with username.
if [[ "$(pwd)" != "$HOME" ]]
then
    cd ~;
    center "Moved to $(pwd)" "$RED"
fi
}

download_chocolatey() {
center "Running Chocolatey Install" "$BLUE"
# ### Chocolatey install
 powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%/chocolatey/bin"
}

setup_terminal() {
center "Setting up windows terminal" "$BOLD"
center "Terminal: Installing Cascadia-Code font" "$MAGENTA"
# ## Add cascadiacode font for windows terminal
 choco install cascadiacode -fy

center "Terminal: Installing Windows Terminal" "$MAGENTA"
# ## Install Windows Terminal
 choco install microsoft-windows-terminal -fy

center "Terminal: Symlinking Windows Terminal Settings" "$MAGENTA"
# ## Add a symlink for Windows Terminal settings.
 ln -sf ~/.dotfiles/windows-terminal-settings.json $LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json
}

setup_dotfiles(){
center "Dotfile: Symlinking settings" "$BOLD"
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

download_packages() {
center "Downloading Applications" "$BOLD"
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
    center "Setting up development tools" "$BOLD"

    center "Dev Tool: Installing Git" "$YELLOW"
     choco install git -fy
    command_exists git || {
        error "git is not installed"
        exit 1
    }


    center "Dev Tool: Installing Node Version Manager" "$YELLOW"
     choco install nvm -fy

    center "Dev Tool: Installing Node.js" "$YELLOW"
     nvm install latest
    
    center "Dev Tool: Installing Yarn" "$YELLOW"
     choco install yarn -fy

    center "Dev Tool: Installing Python" "$YELLOW"
     choco install python -fy

    center "Dev Tool: Installing Java JDK 11" "$YELLOW"
     choco install jdk11 -fy
    center "Dev Tool: Installing VirtualBox" "$YELLOW"
     choco install virtualbox -fy
}

default_windows_settings() {
       # powershell.exe -noprofile -executionpolicy bypass –RunAsAdministrator -file ./windows.ps1
}

main() {
   check_directory
   default_windows_settings
   download_chocolatey

   command_exists git || {
        error "choco is not installed"
        exit 1
    }

   setup_terminal
   download_packages
   setup_dotfiles
   setup_devtools
}

main