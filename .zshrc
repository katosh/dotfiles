# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=5000
setopt appendhistory autocd extendedglob notify
unsetopt beep
bindkey -v
zstyle :compinstall filename '/Users/dominik/.zshrc'

autoload -Uz compinit
compinit

# enable keep
autoload -U keeper && keeper

# make directory stack to skip back to previous directory
setopt AUTO_PUSHD
setopt pushdminus # invert +/- arguments

# costemize promt
#                  normel user        ||       root
(( EUID )) && PROMPT='%U%n:%m%u %/> ' || PROMPT='%U%n:%m%u %/# '

# Cache completion for better preformance
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Autocorection for comliton
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
# .. and tolerance for one error
# zstyle ':completion:*:approximate:*' max-errors 1 numeric
# .. and text-length dependent error-tolerance
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'
# .. and ignore completion functions for commands I dont have
zstyle ':completion:*:functions' ignored-patterns '_*'

# cd will never select the parent directory (e.g.: cd ../<TAB>)
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# completion format
zstyle ':completion:*:descriptions' format $'%{\e[0;31m%}%d%{\e[0m%}'
zstyle ':completion:*:corrections' format $'%{\e[0;31m%}%d%{\e[0m%}'
zstyle ':completion:*:message' format $'%{\e[0;31m%}%d%{\e[0m%}'
zstyle ':completion:*:warnings' format $'%{\e[0;31m%}%d%{\e[0m%}'

# group completions
zstyle ':completion:*' group-name ''

# completion menu
zstyle ':completion:*' menu select=2

# some options
setopt append_history
setopt extended_history # time log
setopt share_history
setopt hist_reduce_blanks

# aliases for most used calls
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -g g='| grep'
alias v='vim'
alias sv='sudo vim'

# tmux 256 color support
alias tmux="tmux -2"

# display most used commands
alias mostused='fc -l 1 -1|awk '"'"'{print $2}'"'"'|awk '"'"'BEGIN {FS="|"} {print $1}'"'"'|sort|uniq -c|sort -n -r|less'

# fix pitch for all speeds
alias mps='mplayer -af scaletempo'

# geting my ip
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'

# autocorrection for commands on return
setopt correct

# for fast renaming with regular expressions
autoload -U zmv

# python config with autocompletion
export PYTHONSTARTUP="$HOME/.pythonrc"
# python site packages
export PYTHONPATH=/usr/local/Cellar/opencv/2.4.11_1/lib/python2.7/site-packages

# git aliases
alias gco='git checkout'
alias gci='git commit -am'
alias grb='git rebase'
alias gpu='git push'
alias gpl='git pull'
alias gme='git merge --no-commit'

# favorit rsync
alias c='rsync -ah --progress'

## some automations
# vim open filetype in taps
vto() {
    vim -p *.$1
}

## keybindings

bindkey "^[[A"  history-beginning-search-backward
bindkey "^[[B"  history-beginning-search-forward


export PATH="/bin:$PATH"
export PATH="/sbin:$PATH"
export PATH="/usr/bin:$PATH"
export PATH="/usr/sbin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export EDITOR="/usr/local/bin/vim"
# adding /usr/texbin to PATH for MacTeX
eval `/usr/libexec/path_helper -s`
# git keychain
git config --global credential.helper osxkeychain
# blender in Command-Line
if [ -e /Applications/Blender/blender.app ]; then
    alias blender=/Applications/Blender/blender.app/Contents/MacOS/blender
fi
# colors for less
#export LESSOPEN='| ~/.lessfilter'
if [ source-highlight ]; then
    export LESSOPEN="$LESSOPEN | source-highlight --style-file=esc-solarized.style -f esc -i"
fi
export LESSOPEN="$LESSOPEN %s"
export LESS=' -R '
# often used commands
alias b='brew'
# enable color support of ls and gls
if [ "$TERM" != "dumb" ]; then
        alias ls='ls -GF'
        export CLICOLOR_FORCE="yes" # force colors
        if [ command -v gls >/dev/null 2>&1 ]; then
            alias gls='gls --color=always'
            eval $(gdircolors $HOME/.dircolors)
        fi
fi
alias la='ls -a'
alias ll='ls -lA'          # ohne . und ..
alias llh='ls -lh'
alias gla='gls -a'
alias gll='gls -lA'          # ohne . und ..
alias gllh='gls -lh'

# programms
alias matl='/Applications/MATLAB_R2014a.app/bin/matlab -nosplash -nodesktop'

# mutt emaul client
export MUTT_EMAIL_ADDRESS="dominik.otto@gmail.com"
export MUTT_REALNAME="Dominik Otto"
export MUTT_SMTP_URL="smtp://dominik.otto@smtp.gmail.com:587/"

# add local configurations
if [ -f $HOME/.localrc ]; then source $HOME/.localrc; fi

# summ disc usage of all files/directorys that fit the name pattern
sfn(){
    find . -name "$*" -print0 | gdu --files0-from=- -hc | tail -n1
}
