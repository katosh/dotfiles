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
alias -g g='| grep -i'
alias v='vim --servername VIM'
alias sv='sudo vim'

# ssh aliases
alias Mi='ssh -X mi'
alias Zedat='ssh -X zedat'
alias Pi='ssh -X pi'
alias Piw='ssh -X piw'
alias Pii='ssh -X pii'

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

# python config with autocompletion
export PYTHONSTARTUP="$HOME/.pythonrc"
# python site packages
export PYTHONPATH=/usr/local/lib/python3.3/site-packages

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
bindkey "OA"  history-beginning-search-backward
bindkey "OB"  history-beginning-search-forward

export EDITOR="/usr/bin/vim"

# often used commands
alias ag='sudo apt-get'
alias ac='apt-cache'
alias ap='sudo aptitude'

# enable color support of ls
if [ "$TERM" != "dumb" ]; then
        alias ls='ls --color=always'
        eval $(dircolors ~/.dircolors)
fi
#LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
export LS_COLORS
alias la='ls -a'
alias ll='ls -lA'          # ohne . und ..
alias llh='ls -lh'

# Tockens
if [ -f $HOME/.tokens ]; then source $HOME/.tokens; fi

# mutt emaul client
export MUTT_EMAIL_ADDRESS="dominik.otto@gmail.com"
export MUTT_REALNAME="Dominik Otto"
export MUTT_SMTP_URL="smtp://dominik.otto@smtp.gmail.com:587/"

# bitly alias
if [ -f $HOME/Scripts/bitly.py ]; then
    alias bitly='$HOME/Scripts/bitly.py'
fi

# matlab alias
if command -v matlab >/dev/null 2>&1; then
    alias matl='matlab -nodesktop -nosplash'
fi

# add local configurations
if [ -f $HOME/.localrc ]; then source $HOME/.localrc; fi

# sum disc usage of all files/directorys that fit the name pattern
sfn(){
    find . -name "$*" -print0 | du --files0-from=- -hc | tail -n1
}

# display csv
dcsv(){
    cat $* | sed -e 's/;;/; ;/g' | sed -e 's/^;/ ;/g' | column -s";" -t | less -N -S
}
dccsv(){
    cat $* | sed -e 's/,,/, ,/g' | sed -e 's/^,/ ,/g' | column -s"," -t | less -N -S
}
dtab(){
    cat $* | column -t | less -N -S
}
stdl(){
    ssh dominik@ottoslink.de "wget -O - ${1}" >> ${1##*/}
}
alias initRM="/bin/ls > README"

# use oh-my-zsh if exists
# to install: sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
if [ -f $HOME/.oh-my-zsh/oh-my-zsh.sh ]; then
    export ZSH=$HOME/.oh-my-zsh
    ZSH_THEME="robbyrussell"
    plugins=(git tmux)
    source $ZSH/oh-my-zsh.sh
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
  echo $w > /tmp/w1
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
