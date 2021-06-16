center() {
  termwidth="$(tput cols)"
  padding="$(printf '%0.1s' ={1..500})"

  textColor="${2:-$WHITE}"
  lineColor="${3:-$textColor}"
  printf '\n%s%*.*s %s%s%s %*.*s\n' "$lineColor" 0 "$(((termwidth-2-${#1})/2))" "$padding" "$textColor" "$1" "$lineColor" 0 "$(((termwidth-1-${#1})/2))" "$padding" "$2"
}

setup_dotfiles(){
  rm -rf ~/.bash_aliases
  rm -rf ~/.bash_profile
  rm -rf ~/.bashrc
  rm -rf ~/.gitconfig
center "Dotfile: Symlinking settings" "$GREEN"
# ## Symlink dot files.
center "Linking .bash_aliases" "$GREEN"
ln -sf ~/.dotfiles/.bash_aliases ~/.bash_aliases 
center "Linking .bashrc" "$GREEN"
ln -sf ~/.dotfiles/.bashrc ~/.bashrc 
center "Linking .bash_profile" "$GREEN"
 ln -sf ~/.dotfiles/.bash_profile ~/.bash_profile
center "Linking .gitconfig" "$GREEN"
 ln -sf ~/.dotfiles/.gitconfig ~/.gitconfig
center "Linking .vscode" "$GREEN"
 ln -sf ~/.dotfiles/.vscode ~/.vscode
center "Linking VSCode settings.json" "$GREEN"
 ln -sf ~/.dotfiles/.vscode/settings.json $APPDATA/Code/User/settings.json
}

setup_dotfiles