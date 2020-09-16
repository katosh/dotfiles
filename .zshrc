# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=50000
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
setopt hist_ignore_all_dups

# autocorrection for commands on return
setopt correct

# for fast renaming with regular expressions
autoload -U zmv

# python config with autocompletion
#export PYTHONSTARTUP="$HOME/.pythonrc"
# python site packages
#export PYTHONPATH=/usr/local/Cellar/opencv/2.4.11_1/lib/python2.7/site-packages
#export PATH=$PATH:/Users/dominik/Library/Python/3.7/bin

## keybindings
bindkey "^[[A"  history-beginning-search-backward
bindkey "^[[B"  history-beginning-search-forward

export EDITOR="/usr/local/bin/vim"

# mutt emaul client
export MUTT_EMAIL_ADDRESS="dominik.otto@gmail.com"
export MUTT_REALNAME="Dominik Otto"
export MUTT_SMTP_URL="smtp://dominik.otto@smtp.gmail.com:587/"


# add local configurations
if [ -f $HOME/.localrc ]; then source $HOME/.localrc; fi

## some automations
# vim open filetype in taps
vto() {
    vim -p *.$1
}

# sum disc usage of all files/directorys that fit the name pattern
sfn(){
    find . -name "$*" -print0 | du --files0-from=- -hc | tail -n1
}

# display csv
dcsv(){
    cat $* | sed -e 's/,,/, ,/g' | column -s";" -t | less -N -S
}
dccsv(){
    cat $* | column -s"," -t | less -N -S
}
dtab(){
    cat $* | column -t | less -N -S
}
stdl(){
    ssh dominik@ottoslink.de "wget -O - ${1}" >> ${1##*/}
}
p(){
    if [[ -d "$1" ]]; then
        (cd "$1"; pwd -P)
    else
        (cd $(dirname "$1"); echo "$(pwd -P)/$(basename "$1")")
    fi
}

# use oh-my-zsh if exists
# to install: sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
if [ -f $HOME/.oh-my-zsh/oh-my-zsh.sh ]; then
    export ZSH=$HOME/.oh-my-zsh
    ZSH_THEME="robbyrussell"
    plugins=(git tmux)
    source $ZSH/oh-my-zsh.sh
fi

## Aliases

if command -v matlab >/dev/null 2>&1; then
    alias matl='matlab -nodesktop -nosplash'
fi
alias initRM="/bin/ls > README"
alias c='rsync -ah --progress'

# aliases for most used calls
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -g g='| grep -i'
alias v='vim'
alias sv='sudo vim'

# tmux 256 color support
alias tmux="tmux -2"

# test if colors are displayed
alias coltest='(x=`tput op` y=`printf %76s`;for i in {0..256};do o=00$i;echo -e ${o:${#o}-3:3} `tput setaf $i;tput setab $i`${y// /=}$x;done)'

# display most used commands
alias mostused='fc -l 1 -1|awk '"'"'{print $2}'"'"'|awk '"'"'BEGIN {FS="|"} {print $1}'"'"'|sort|uniq -c|sort -n -r|less'

# fix pitch for all speeds
alias mps='mplayer -af scaletempo'

# geting my ip
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'


# git aliases
alias gco='git checkout'
alias gci='git commit -m'
alias grb='git rebase'
alias gpu='git push'
alias gpl='git pull'
alias gme='git merge --no-commit'


# my expand aliases
globalias() {
   zle _expand_alias
   zle expand-word
}
zle -N globalias
bindkey "^ " globalias
