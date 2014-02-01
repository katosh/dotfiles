#!/bin/zsh

# this script will automaticly install the dotfiles from the repo and back up the old ones
# to execute type:
# chmod u+x install.sh
# ./install.sh

########## Variables
# list of files/folders to symlink in homedir
files=('.vimrc' '.vim' '.zshrc' '.pythonrc' '.vim_python_style')
# dotfiles directory
dir=$0
# old dotfiles backup directory
olddir="$HOME/dotfiles_old"

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
echo "Moving any existing dotfiles from $HOME to $olddir"
for file in $files; do
    if [ -f $HOME/$file ]; then
        mv $HOME/$file $olddir
    fi
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file $HOME/
done
