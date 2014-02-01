 #!/bin/zsh

# this script will automaticly install the dotfiles from the repo and back up the old ones

########## Variables

dir=$( cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P )                    # dotfiles directory
olddir="$HOME/dotfiles_old"             # old dotfiles backup directory
files=('.vimrc' '.vim' '.zshrc' '.pythonrc' '.vim_python_style')    # list of files/folders to symlink in homedir

echo "we are in $dir"

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
echo "Moving any existing dotfiles from $HOME to $olddir"
for file in $files; do
    mv $HOME/$file $olddir
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file $HOME/$file
done
