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

    # Recreate the bin/tmux → hooks/tmux-cmux-shim symlink (not tracked in git)
    mkdir -p "$claude_dst/bin"
    if [ -L "$claude_dst/bin/tmux" ]; then
        rm "$claude_dst/bin/tmux"
    fi
    ln -s "../hooks/tmux-cmux-shim" "$claude_dst/bin/tmux"
    echo "  .claude/bin/tmux → ../hooks/tmux-cmux-shim"
fi

# --- MCP server setup ---
echo "==> Setting up proxy-fetch MCP server"
mcp_dir="$claude_dst/mcp-servers/proxy-fetch"
if [ -d "$mcp_dir" ]; then
    # Install Python dependencies
    if command -v uv &>/dev/null; then
        echo "  Running uv sync in $mcp_dir"
        (cd "$mcp_dir" && uv sync)
    else
        echo "  WARNING: uv not found, skipping dependency install for proxy-fetch"
    fi

    # Register MCP server with Claude Code
    if command -v claude &>/dev/null; then
        echo "  Registering proxy-fetch MCP server"
        claude mcp add -e SOCKS_PROXY=socks5://localhost:1080 -s user proxy-fetch -- \
            uv run --directory "$mcp_dir" python server.py || true
    else
        echo "  WARNING: claude CLI not found, skipping MCP server registration"
    fi
fi

echo "==> Done!"
