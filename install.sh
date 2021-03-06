#!/bin/zsh

# this script will automaticly install the dotfiles from the repo and back up the old ones
# to execute type:
# chmod u+x install.sh
# ./install.sh

########## Variables
# list of files/folders to symlink in homedir
files=('.vimrc' '.tmux.conf' '.vim' '.zshrc' '.pythonrc' '.vim_python_style' '.dircolors' '.gitconfig')

# dotfiles directory
dir=$( cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P )
# old dotfiles backup directory
olddir="$HOME/dotfiles_old"

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
echo "Moving any existing dotfiles from $HOME to $olddir"
for file in $files; do
    [ -f $HOME/$file ] && mv $HOME/$file $olddir
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file $HOME/
done
touch $HOME/.hushlogin
