#!/bin/zsh

# Dotfiles installer — symlinks flat dotfiles and the .claude/ config tree.
#
# Usage:
#   chmod u+x install.sh
#   ./install.sh

set -euo pipefail

########## Variables

# Flat files/folders to symlink into $HOME
files=('.vimrc' '.tmux.conf' '.vim' '.zshrc' '.pythonrc' '.vim_python_style' '.dircolors' '.gitconfig')

# Dotfiles directory (where this script lives)
dir=$( cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P )

# Backup directory for originals
olddir="$HOME/dotfiles_old"

##########

echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p "$olddir"

# --- Flat dotfiles ---
echo "==> Symlinking flat dotfiles"
for file in $files; do
    target="$HOME/$file"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "  Backing up $target → $olddir/"
        mv "$target" "$olddir/"
    fi
    if [ -L "$target" ]; then
        rm "$target"
    fi
    echo "  $file → $target"
    ln -s "$dir/$file" "$target"
done
touch "$HOME/.hushlogin"

# --- Claude Code config tree ---
echo "==> Symlinking .claude/ config files"
claude_src="$dir/.claude"
claude_dst="$HOME/.claude"

if [ -d "$claude_src" ]; then
    # Find all regular files in the repo's .claude/ and symlink each one
    find "$claude_src" -type f | while read -r src_file; do
        rel="${src_file#$claude_src/}"
        dst_file="$claude_dst/$rel"
        dst_dir="$(dirname "$dst_file")"

        mkdir -p "$dst_dir"

        if [ -e "$dst_file" ] && [ ! -L "$dst_file" ]; then
            backup_dir="$olddir/.claude/$(dirname "$rel")"
            mkdir -p "$backup_dir"
            echo "  Backing up $dst_file → $backup_dir/"
            mv "$dst_file" "$backup_dir/"
        fi
        if [ -L "$dst_file" ]; then
            rm "$dst_file"
        fi
        echo "  .claude/$rel → $dst_file"
        ln -s "$src_file" "$dst_file"
    done

fi

echo "==> Done!"
