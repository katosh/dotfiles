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

alias la='ls -a'
alias ll='ls -lA'          # ohne . und ..
alias llh='ls -lh'

# aliases for most used calls
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -g g='| grep'
alias v='vim'
alias sv='sudo vim'

# ssh aliases
alias Mi='ssh -X mi'
alias Zedat='ssh -X zedat'
alias Pi='ssh -X pi'
alias Piw='ssh -X piw'
Pii(){
    rip=`lynx --dump http://userpage.fu-berlin.de/katosh/piip.txt | xargs -n 1 | tail -1`
    ssh pi@$rip
}

# tmux 256 color support
alias tmux="tmux -2"

# test if colors are displayed
alias coltest='(x=`tput op` y=`printf %76s`;for i in {0..256};do o=00$i;echo -e ${o:${#o}-3:3} `tput setaf $i;tput setab $i`${y// /=}$x;done)'

# display most used commands
alias mostused='fc -l 1 -1|awk '"'"'{print $2}'"'"'|awk '"'"'BEGIN {FS="|"} {print $1}'"'"'|sort|uniq -c|sort -n -r|less'

# fix pitch for all speeds
alias mps='mplayer -af scaletempo'

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

## some automations
# vim open filetype in taps
vto() {
    vim -p *.$1
}


#### LINUX/GNU ####
if [[ "$OSTYPE" == "linux-gnueabi" || "$OSTYPE" == "linux-gnu" ]]; then
    git config --global credential.helper cache
    git config --global credential.helper 'cache --timeout=3600'
    if [ source-highlight ]; then
        export LESSOPEN="| source-highlight %s"
        export LESS=' -R '
    fi

    # often used commands
    alias ag='sudo apt-get'
    alias ap='sudo aptitude'
    alias sup='sudo pm-suspend'
    alias sdown='sudo halt'

    # enable color support of ls
    if [ "$TERM" != "dumb" ]; then
            alias ls='ls --color=always'
            eval $(dircolors ~/.dircolors)
    fi
    #LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
    export LS_COLORS


#### MAC OSX ####
elif [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="/bin:$PATH"
    export PATH="/sbin:$PATH"
    export PATH="/usr/bin:$PATH"
    export PATH="/usr/sbin:$PATH"
    export PATH="/usr/local/bin:$PATH"
    export PATH="/usr/local/sbin:$PATH"
    # LaTex progs
    export PATH="$PATH:/usr/texbin"
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
    # enable color support of ls
    if [ "$TERM" != "dumb" ]; then
            alias ls='ls -GF'
            export CLICOLOR_FORCE="yes" # force colors
    fi
    # programms
    alias matl='/Applications/MATLAB_R2014a.app/bin/matlab -nosplash -nodesktop'

#### CYG-WIN ###
elif [[ "$OSTYPE" == "cygwin" ]]; then
    # enable color support of ls
    if [ "$TERM" != "dumb" ]; then
            alias ls='ls --color=always'
            eval $(dircolors ~/.dircolors)
    fi
    # often used commands
    alias ac='apt-cyg'
    # in the MDC
    alias silac='cd /cygdrive/z/Dominik/model\ files\ Matlab'
elif [[ "$OSTYPE" == "win32" ]]; then
        # ...
elif [[ "$OSTYPE" == "freebsd"* ]]; then
        # ...
else
        # Unknown.
fi

# Tockens
if [ -f $HOME/.tokens ]; then source $HOME/.tokens; fi

# mutt emaul client
export MUTT_EMAIL_ADDRESS="dominik.otto@gmail.com"
export MUTT_REALNAME="Dominik Otto"
export MUTT_SMTP_URL="smtp://dominik.otto@smtp.gmail.com:587/"

# for the symmetry project
if [ -d $HOME/Symmetry ]; then
    export PYTHONPATH="$PYTHONPATH:$HOME/Symmetry/"
fi

# bitly alias
if [ -f $HOME/Scripts/bitly.py ]; then
    alias bitly='$HOME/Scripts/bitly.py'
fi

# matlab alias
if command -v matlab >/dev/null 2>&1; then
    alias matl='matlab -nodesktop -nosplash'
fi
