# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
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
#                  normel user     ||       root
(( EUID )) && PROMPT='%U%n:%m%u> ' || PROMPT='%U%n:%m%u# '


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

# autocorrection for commands on return
setopt correct

# for fast renaming with regular expressions
autoload -U zmv

## some automations
# vim open filetype in taps
vto() {
    nvim -p *.$1
}

## keybindings
bindkey "OA"  history-beginning-search-backward
bindkey "OB"  history-beginning-search-forward

export EDITOR="/usr/bin/vim"

# often used commands
alias ag='sudo apt'
alias ac='apt-cache'
alias ap='sudo aptitude'

# enable color support of ls
if [ "$TERM" != "dumb" ]; then
        alias ls='ls --color=always'
        eval $(dircolors ~/.dircolors)
fi
# often used commands
alias ac='apt-cyg'
# in the MDC
alias -g silacd='/cygdrive/c/Users/dotto/Documents/Dominik/matlab'

#LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
export LS_COLORS

# Tockens
if [ -f $HOME/.tokens ]; then source $HOME/.tokens; fi

# mutt emaul client
export MUTT_EMAIL_ADDRESS="dominik.otto@gmail.com"
export MUTT_REALNAME="Dominik Otto"
export MUTT_SMTP_URL="smtp://dominik.otto@smtp.gmail.com:587/"

# add local configurations
if [ -f $HOME/.localrc ]; then source $HOME/.localrc; fi

# sum disc usage of all files/directorys that fit the name pattern
sfn(){
    find . -name "$*" -print0 | du --files0-from=- -hc | tail -n1
}

alternateColor() {
    (( i = 1 ))
    while read line
    do
        echo -e "\e[$(( i % 6 + 36 ))m$line"
        (( i = i - 1 ))
    done
    echo -en "\e[0m"
}

# display csv
# column.py is from https://github.com/hq6/column
dcsv()(
    task(){cat - | sed -e 's/;;/; ;/g' | sed -e 's/^;/ ;/g' | column.py -s";" |
        alternateColor | less -RNS}
    if [ -t 0 ]; then
      if [ $# -gt 0 ]; then
        cat $* | task
      fi
    else
      cat - | task
    fi
)
dccsv()(
    task(){cat - | sed -e 's/,,/, ,/g' | sed -e 's/^\,/ ,/g' | column.py -s"," |
        alternateColor | less -RNS}
    if [ -t 0 ]; then
      if [ $# -gt 0 ]; then
        cat $* | task
      fi
    else
      cat - | task
    fi
)
dtsv()(
    task(){cat - | tr "\t" ";" | dcsv}
    if [ -t 0 ]; then
      if [ $# -gt 0 ]; then
        cat $* | task
      fi
    else
      cat - | task
    fi
)
dctsv()(
    task(){cat - | sed -e 's/;;/; ;/g' | sed -e 's/^;/ ;/g' |
        column -s";"$'\t' -t | alternateColor | less -NSR}
    if [ -t 0 ]; then
      if [ $# -gt 0 ]; then
        cat $* | task
      fi
    else
      cat - | task
    fi
)
dgtf()(
    task(){echo $* | grep "^#"; echo $* | grep -v "^#" | sed -e 's/;;/; ;/g' |
        sed -e 's/^;/ ;/g' | column -s";"$'\t' -t | alternateColor}
    if [ -t 0 ]; then
      if [ $# -gt 0 ]; then
          input=$(cat $*)
      fi
    else
        input=$(cat -)
    fi
    task $input | less -NSR
)
stdl(){
    ssh dominik@ottoslink.de "wget -O - ${1}" >> ${1##*/}
}
# a function to pass the absolut path to a given file
p(){
    if [[ -d "$1" ]]; then
        (cd "$1"; pwd -P)
    else
        (cd $(dirname "$1"); echo "$(pwd -P)/$(basename "$1")")
    fi
}
# a function to find all git repos with http(s) and ssh remotes
gitR() {
    [[ $# -eq 0 ]] && dir="$HOME/Projects" || dir="$*"
    echo -e "DIRECTORY\tREMOTE"
    find "$dir" -name HEAD \
        -execdir test -e refs -a -e objects -a -e config \; -printf %h\\n |
    while read repo; do
        DIR=${$(dirname "$repo")/$HOME/\~}
        git --git-dir="$repo" remote -v | awk '{print $2}' |
            grep -E 'http|@' | sort | uniq |
        while read remote; do
            if [[ "$remote" =~ "http.*" ]]; then
                echo -e "$DIR\t${remote##http?://}"
            else
                echo -e "$DIR\t${${${remote/*@/}/://}%%.git}"
            fi
        done
    done
}

rmColor(){
    # Removes ansi terminal colors from text when piped through.
    sed -r "s/[[:cntrl:]]\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g"
}
# use oh-my-zsh if exists
# to install: sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
#if [[ (-f $HOME/.oh-my-zsh/oh-my-zsh.sh) && ($(hostname) != "ribnodevm1404") ]]; then
#    export ZSH=$HOME/.oh-my-zsh
#    DEFAULT_USER="dominik.otto"
#    ZSH_THEME="robbyrussell"
#    plugins=(git zsh-autosuggestions zsh-syntax-highlighting vi-mode)
#    source $ZSH/oh-my-zsh.sh
#fi
export DISABLE_AUTO_TITLE=true

alias initRM="/bin/ls > README"

# git aliases
alias gco='git checkout'
alias gci='git commit -m'
alias grb='git rebase'
alias gpu='git push'
alias gpl='git pull'
alias gme='git merge --no-commit'

# aliases for most used calls
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -g g='| grep -i'
#alias v='vim --servername VIM'
alias nv='nvim'
alias sv='sudo -H vim'
# fff https://github.com/dylanaraps/fff
alias f=fff


# feh aliases
alias pfeh='feh --magick-timeout 1'
alias sfeh='feh --scale-down --auto-zoom'

# ssh aliases
alias Mi='ssh -X mi'
alias Zedat='ssh -X zedat'
alias Pi='ssh -X pi'
alias Piw='ssh -X piw'
alias Pii='ssh -X pii'

# locate aliases
alias lupdatedb="updatedb -o $HOME/.locate.db --require-visibility 0 \
    --prunefs 'rpc_pipefs cgroup proc ftpfs devfs tmpfs fuse.sshfs curlftpfs \
    mqueue debugfs fusectl pstore efivarfs hugetlbfs sysfs devtmpfs devpts'
    chmod 600 $HOME/.locate.db"
alias llocate="locate --database=$HOME/.locate.db"


# favorit rsync
alias c='rsync -ah --progress'

alias la='ls -a'
alias ll='ls -lA'          # ohne . und ..
alias llh='ls -lh'

# bitly alias
if [ -f $HOME/Scripts/bitly.py ]; then
    alias bitly='$HOME/Scripts/bitly.py'
fi

# matlab alias
if command -v matlab >/dev/null 2>&1; then
    alias matl='matlab -nodesktop -nosplash'
fi

# my expand aliases
globalias() {
   zle _expand_alias
   zle expand-word
}
zle -N globalias
bindkey "^ " globalias

# Complete words from tmux pane(s) {{{1
# Source: http://blog.plenz.com/2012-01/zsh-complete-words-from-tmux-pane.html
# Gist: https://gist.github.com/blueyed/6856354
_tmux_pane_words() {
  local expl
  local -a w
  if [[ -z "$TMUX_PANE" ]]; then
    _message "not running inside tmux!"
    return 1
  fi

  # Based on vim-tmuxcomplete's splitwords function.
  # https://github.com/wellle/tmux-complete.vim/blob/master/sh/tmuxcomplete
  _tmux_capture_pane() {
    tmux capture-pane -J -p -S -100 $@ |
      # Remove "^C".
      sed 's/\^C\S*/ /g' |
      # copy lines and split words
      sed -e 'p;s/[^a-zA-Z0-9_]/ /g' |
      # split on spaces
      tr -s '[:space:]' '\n' |
      # remove surrounding non-word characters
      =grep -o "\w.*\w"
  }
  # Capture current pane first.
  w=( ${(u)=$(_tmux_capture_pane)} )
  local i
  for i in $(tmux list-panes -F '#D'); do
    # Skip current pane (handled before).
    [[ "$TMUX_PANE" = "$i" ]] && continue
    w+=( ${(u)=$(_tmux_capture_pane -t $i)} )
  done
  _wanted values expl 'words from current tmux pane' compadd -a w
}

zle -C tmux-pane-words-prefix   complete-word _generic
zle -C tmux-pane-words-anywhere complete-word _generic
bindkey '^Xt' tmux-pane-words-prefix
bindkey '^X^X' tmux-pane-words-anywhere
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' completer _tmux_pane_words
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' ignore-line current
# Display the (interactive) menu on first execution of the hotkey.
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' menu yes select interactive
# zstyle ':completion:tmux-pane-words-anywhere:*' matcher-list 'b:=* m:{A-Za-z}={a-zA-Z}'
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' matcher-list 'b:=* m:{A-Za-z}={a-zA-Z}'
# }}}

