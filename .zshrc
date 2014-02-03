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

# costemize promt
PROMPT='%U%n:%m%u %/> '

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

# some options
setopt append_history
setopt extended_history # time log
setopt share_history
setopt hist_reduce_blanks

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    alias ls='ls -G'
    #alias l='ls -CF'
    alias la='ls -a'
    alias ll='ls -lA'          # ohne . und ..
    alias llh='ls -lh'
fi

# aliases for most used calls
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -g g='| grep'
alias v='vim'

# ssh aliases
alias Mi='ssh -X mi'
alias Pi='ssh -X pi'
alias Zedat='ssh -X zedat'
Pii(){
    rip=`lynx --dump http://userpage.fu-berlin.de/katosh/piip.txt | xargs -n 1 | tail -1`
    ssh pi@$rip
}

# tmux 256 color support
alias tmux="tmux -2"

# display most used commands
alias mostused='fc -l 1 -1|awk '"'"'{print $2}'"'"'|awk '"'"'BEGIN {FS="|"} {print $1}'"'"'|sort|uniq -c|sort -r|head -16'

# autocorrection for commands on return
setopt correct

# for fast renaming with regular expressions
autoload -U zmv

# python config with autocompletion
export PYTHONSTARTUP="$HOME/.pythonrc"
# python site packages
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH

# git aliases
alias gco='git ccheckout'
alias gci='git commit -am'
alias grb='git rebase'
alias gpu='git push'
alias gpl='git pull'


#### LINUX/GNU ####
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    git config --global credential.helper cache
    git config --global credential.helper 'cache --timeout=3600'
    if [ source-highlight ]; then
        export LESSOPEN="| source-highlight %s"
        export LESS=' -R '
    fi
    # often used commands
    alias ag='sudo apl-get'


#### MAC OSX ####
elif [[ "$OSTYPE" == "darwin"* ]]; then
    git config --global credential.helper osxkeychain
    # blender in Command-Line
    if [ -f /Applications/Blender/blender.app ]; then
        alias blender=/Applications/Blender/blender.app/Contents/MacOS/blender
    fi
    # syntax-highlight for less if installed
    if [ source-highlight ]; then
        export LESSOPEN="| source-highlight --style-file=esc-solarized.style -f esc -i %s"
        export LESS=' -R '
    fi
    # often used commands
    alias b='brew'


#### CYG-WIN ###
elif [[ "$OSTYPE" == "cygwin" ]]; then
        # ...


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
if [ -f $HOME/Symmetry ]; then
    export PYTHONPATH="$PYTHONPATH:$HOME/Symmetry/"
fi

