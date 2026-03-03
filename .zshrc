# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory autocd extendedglob notify
unsetopt beep
bindkey -v
zstyle :compinstall filename '/Users/dominik/.zshrc'

echo 1-$(date +"%Y-%m-%d_%H:%M:%S")-------------------------
autoload -Uz compinit
compinit

# enable keep
autoload -U keeper && keeper

# make directory stack to skip back to previous directory
setopt AUTO_PUSHD
setopt pushdminus # invert +/- arguments

# costemize promt
#                  normel user     ||       root
(( EUID )) && PROMPT='%T:%U%m%u> ' || PROMPT='%U%n:%m%u# '


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

# autocorrection for commands on return
setopt correct

# for fast renaming with regular expressions
autoload -U zmv

## some automations
# vim open filetype in taps
vto() {
    vim -p *.$1
}
alias v=vim

## keybindings
bindkey "OA"  history-beginning-search-backward
bindkey "OB"  history-beginning-search-forward

export EDITOR="/usr/bin/vim"

# often used commands
alias ag='sudo apt-get'
alias ac='apt-cache'
alias ap='sudo aptitude'

#LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
export LS_COLORS

# language settings
export LANG=en_US.utf8
export LC_ALL=en_US.utf8

# Tockens
if [ -f $HOME/.tokens ]; then source $HOME/.tokens; fi

# mutt emaul client
export MUTT_EMAIL_ADDRESS="dominik.otto@gmail.com"
export MUTT_REALNAME="Dominik Otto"
export MUTT_SMTP_URL="smtp://dominik.otto@smtp.gmail.com:587/"

# sum disc usage of all files/directorys that fit the name pattern
sfn(){
    find . -name "$*" -print0 | du --files0-from=- -hc | tail -n1
}

# memory usage by user in MB
usermem () {
    # Gather RSS memory (in KiB) and user from all processes
    ps hax -o rss,user | \
    
    # Sum RSS memory per user and output: <user> <bytes>
    awk '{
        a[$2]+=$1;
    } END {
        for (i in a) {
            bytes = a[i] * 1024;  # convert KiB to bytes
            print i, bytes;
        }
    }' | \
    
    # Sort descending by total memory usage (in bytes)
    sort -k2 -rn | \
    
    # Convert to human-readable sizes
    awk '{
        size = $2;
        hum = "B";
        split("K M G T", unit);
        for (j=1; size>=1024 && j<=4; j++) {
            size /= 1024;
            hum = unit[j];
        }
        printf "%-10s %7.2f %sB\n", $1, size, hum;
    }'
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

# ls aliases
alias ls='ls -G'
alias ll='ls -GlA'

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

# locate aliases
alias lupdatedb="updatedb -o $HOME/.locate.db --require-visibility 0 \
    --prunefs 'rpc_pipefs cgroup proc ftpfs devfs tmpfs fuse.sshfs curlftpfs \
    mqueue debugfs fusectl pstore efivarfs hugetlbfs sysfs devtmpfs devpts'
    chmod 600 $HOME/.locate.db"
alias llocate="locate --database=$HOME/.locate.db"


# favorit rsync
alias c='rsync -ah --progress'

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

_glcompleter() {
    read -l
    local cl="$REPLY"
    read -ln
    local cp="$REPLY"
    reply=(`COMP_LINE="$cl" COMP_POINT="$cp" gl`)
}
compctl -K _glcompleter gl

alias nodes="sinfo -No '%N;%t;%f;%m;%e;%z;%O;%G;%v' | uniq | column -t -s ';' | alternateColor"
alias ishell="srun --mem=4G --cpus-per-task=1 --nodes=1 --ntasks-per-node=1 --time=01:00:00 --pty zsh -i"

export PATH="$HOME/.local/bin:$PATH"

# rename tmux pane if #T in pane-border-format
np(){
    printf '\033]2;%s\033\\' "$*"
}
np '' # clear pane name

# lmod colors
export LMOD_COLORIZE="YES"

# R
export R_DEFAULT_PACKAGES="datasets,utils,grDevices,graphics,stats,methods,colorout"
alias R="R --no-save"

# xpra
#export DISPLAY=:64
export XPRA_DEFAULT_VFB_RESOLUTION=1920x1080

# slurm
alias job_nodes='squeue -h -o '\''%B'\'' | sort | uniq -c | sort -g'
alias nodes='sinfo -N -e -O "nodehost,gres,statecompact,cpus,socketcorethread,cpusstate,cpusload,memory,allocmem" |
    awk  '\''{printf("%s\t%i\t%i\n", $0, $8-$9,gensub(/(.+)\/(.+)\/(.+)\/(.+)/, "\\2", 1))}'\'' |
    awk '\''{if($11>0){printf("%s\t%i\n", $0, $10/$11)}else{print $0 "\tMEM/TH"}}'\'' |
    uniq | column -t | alternateColor'
sq() {
    squeue -o "%i;%P;%R;%j;%u;%a;%T;%M;%l;%C;%m;%b;%p;%q" $@ |
        column -s";" -t | alternateColor
}
squ() {
    squeue -u $USER -o "%i;%P;%R;%j;%u;%a;%T;%M;%l;%C;%m;%b;%p;%q" $@ |
        column -s";" -t | alternateColor
}
sqn() {
	if [ -z "$1" ]; then
        echo "Usage: sqn [ slurm node name ]"
        return 1
    fi
    local node="$1"
    shift # Remove the first argument so that any additional arguments can be passed to squeue
    squeue -o "%i;%P;%R;%j;%u;%a;%T;%M;%l;%V;%C;%m;%b;%p;%q@@@%n@@@" $@ |
        awk -v pattern="@@@${node}@@@" 'NR == 1 || $0 ~ pattern' | 
        sed 's/@@@.*@@@//g' | column -s";" -t | alternateColor
}
sqt() {
    local num_lines

    # Determine if the first argument is a number and greater than 0
    if [[ $1 =~ '^[0-9]+$' && $1 -gt 0 ]]; then
        num_lines=$1
        shift # Safe to shift since we've confirmed there's a valid argument
    else
        num_lines=20 # Default to 20 lines if no (valid) argument is provided
    fi

    squeue -o "%i;%P;%R;%j;%u;%a;%T;%M;%l;%C;%m;%b;%p;%q;%Y" --sort=-p -t PENDING "$@" |
        awk -F ';' '
            NR==1 || 
            /Priority/ ||
            /Resources/' |
        head -n $num_lines |
        column -s";" -t | alternateColor
}

            #!/AssocGrp.*Limit/ && 
            #!/Association.*Limit/ && 
            #!/AssocMax.*Limit/ && 
            #!/BadConstraints/ && 
            #!/DependencyNeverSatisfied/ && 
            #!/Partition.*Limit/ && 
            #!/QOS.*Limit/ && 
            #!/QOSUsageThreshold/ && 
            #!/ReqNodeNotAvail/ && 
            #!/Resources/ && 
            #!/Priority/ && 
            #!/InvalidAccount/ && 
            #!/InvalidQOS/ && 
            #!/JobHeld.*/ && 
            #!/NodeDown/ && 
            #!/PartitionDown/ && 
            #!/PartitionInactive/ && 
            #!/Dependency/ &&
            #!/BeginTime/ &&
            #!/JobArrayTaskLimit/ &&
            #!/Nodes required for job are/ &&
            #!/launch failed requeued held/ &&
            #!/Reservation/' |

alias wsq="watch --color -tx zsh -c 'source $HOME/.alternateColors;
    squeue -S S,-p -o \"%i;%P;%R;%j;%u;%a;%T;%M;%l;%C;%m;%b;%p;%q\" |
    column -s\";\" -t | alternateColor'"
alias sinf='sinfo -o "%N;%G;%t;%P;%D;%a;%c;%z;%C;%O;%m;%d;%w" |
    sed "s/||/| |/g" | column -s";" -t | alternateColor'
alias sp='sprio -o "%i;%u;%Y;%A;%F;%J;%P;%Q;%N" | sort -r |
    column -s";" -t | alternateColor'
alias sqsp='join -t ";" <(squeue -r -o "%A;%F" |
    sed "s/^\([^;]*\);N\/A/\1;\1/g" | sort) \
    <(sprio -o "%i;%Y;%A;%F;%J;%P;%Q;%N" | sort) |
    cut -d ";" -f 2- | uniq | join -a1 -t ";" \
    <(squeue -t PD -o "%F;%i;%P;%r;%j;%u;%a;%M;%l;%C;%m;%b;%q" |
    sed "s/^N\/A;\([^;]*\)/\1;\1/g" | sort) - |
    cut -d ";" -f 2- | sort -n -k13 -t ";" | column -s";" -t | alternateColor'
alias pssqsp='join -t ";" <(squeue -r -o "%A;%F" |
    sed "s/^\([^;]*\);N\/A/\1;\1/g" | sort) \
    <(sprio -o "%i;%Y;%A;%F;%J;%P;%Q;%N" | sort) |
    cut -d ";" -f 2- | uniq | join -a1 -t ";" \
    <(squeue -t PD -o "%F;%i;%P;%r;%j;%u;%a;%M;%l;%C;%m;%b;%q" |
    sed "s/^N\/A;\([^;]*\)/\1;\1/g" | sort) - |
    cut -d ";" -f 2- | sort -t ";" -r -n -k 13,13 | column -s";" -t | alternateColor'
alias sstates='sinfo -N -e -O "nodehost,statecompact" | uniq |
    sed -e "s/^[^ ]*[ ]*//g" | sort | uniq -c'
jobinf(){
    sacct -p -o JobID,JobName,State,Submit,Start,End,NodeList,AllocCPUS,AveCPU,CPUTime,Elapsed,REQMEM,MaxRSS,ExitCode -j "$*" \
    | sed "s/||/| |/g" | column -s '|' -t | alternateColor
}
stail() {
    # Ensure a job ID is provided
    if [[ -z "$1" ]]; then
        echo "Usage: stail [ jobid ] "
        return 1
    fi

    # Retrieve job details
    local response="$(scontrol show job $1 2>&1)"
    
    # Check for errors in response
    if [[ "$response" == *"slurm_load_jobs error"* ]]; then
        echo "$response"
        return 1
    fi

    # Extract StdErr and StdOut paths
    local stderr stdout
    [[ "$response" =~ ' StdErr=([[:print:]]*)' ]] && stderr="${match[1]}"
    [[ "$response" =~ ' StdOut=([[:print:]]*)' ]] && stdout="${match[1]}"

    # Handle placeholder replacement
    stderr=$(echo $stderr | sed 's/%[jNn]/\*/g')
    stdout=$(echo $stdout | sed 's/%[jNn]/\*/g')

    # Check if paths are valid and not empty
    if [[ -z "$stderr" || -z "$stdout" ]]; then
        echo "Error: Could not find log file paths."
        return 1
    fi

    # Tail log files, handling cases where StdErr and StdOut are the same or different
    if [[ "$stderr" != "$stdout" ]]; then
        echo "Tailing StdOut and StdErr:"
        ( tail -f -n+1 $~stdout & tail -f -n+1 $~stderr 1>&2 )
    else
        echo "Tailing StdOut (also used for StdErr):"
        tail -f -n+1 $~stdout
    fi
}

count_files() {
    local dir="${1:-.}"
    local step="${2:-100}"  # default to printing every 100 files
    local count=0

    while IFS= read -r _; do
        (( count++ ))
        if (( count % step == 0 )); then
            printf "\rFiles counted: %'d" "$count"
        fi
    done < <(find "$dir" -type f)
    printf "\rFiles counted: %'d\n" "$count"
}

# quickly probe FS performance: seq. R/W + IOPS
probe_io() {
  local base=${1:-./ziotest}       # base name for test files
  local speed_file="${base}.speed"
  local iops_file="${base}.iops"
  local speed_mb=${2:-1024}        # size for speed test (MB)
  local iops_mb=${3:-128}          # size for IOPS test (MB)
  local bs_iops=1                  # block size in KB for IOPS
  local dev=$(df -P "$PWD" | awk 'NR==2{print $1}')
  local dev_tag=${dev//[\/:]/_}
  local hostname="$(hostname)"
  local logs="$HOME/probe_io_reports"
  local ts=$(date '+%Y-%m-%d_%H%M%S')
  local report="$logs/probe_io_${ts}_${dev_tag}.txt"
  mkdir -p "$logs"

  # Calculate blocks once
  local blocks=$(( iops_mb*1024/bs_iops ))

  {
    echo "Report time : $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Hostname    : $hostname"
    echo "Directory   : $PWD"
    echo "Device      : $dev"
    echo
    echo "=== FS Benchmark on $dev ==="
    echo "-- Sequential speed test (bs=1 MB, total ${speed_mb} MB) --"

    # Sequential write test
    dd if=/dev/zero of="$speed_file" bs=1M count=$speed_mb conv=fdatasync 2>&1 \
      | awk -F', ' '/copied/ { printf "  Write speed: %s %s\n", $(NF-1), $NF }'

    # Sequential read test
    dd if="$speed_file" of=/dev/null bs=1M count=$speed_mb 2>&1 \
      | awk -F', ' '/copied/ { printf "  Read  speed: %s %s\n\n", $(NF-1), $NF }'

    echo "-- IOPS test (bs=${bs_iops} KB, total ${iops_mb} MB) --"

    # Write IOPS test - fixed to properly pass blocks variable to awk
    dd if=/dev/zero of="$iops_file" bs=${bs_iops}K count=$blocks conv=fdatasync 2>&1 \
      | awk -v bs=${bs_iops} -v blocks=$blocks -F', ' '/copied/ {
            t = $3; sub(/ s$/,"",t);
            iops = blocks / t;
            printf "  Write time : %s s\n", t;
            printf "  Write speed: %s\n", $4;
            printf "  Write IOPS : %.0f ops/s\n\n", iops;
        }'

    # Read IOPS test - fixed to properly pass blocks variable to awk
    dd if="$iops_file" of=/dev/null bs=${bs_iops}K count=$blocks 2>&1 \
      | awk -v bs=${bs_iops} -v blocks=$blocks -F', ' '/copied/ {
            t = $3; sub(/ s$/,"",t);
            iops = blocks / t;
            printf "  Read  time : %s s\n", t;
            printf "  Read  speed: %s\n", $4;
            printf "  Read  IOPS : %.0f ops/s\n\n", iops;
        }'

    # cleanup
    rm -f "$speed_file" "$iops_file"

    # need iostat
    command -v iostat &>/dev/null || { echo "iostat not found—install sysstat"; return 1; }

    echo "-- Instantaneous I/O stats (1 s sample) --"
    iostat -x -m "$dev" 1 2 \
      | awk -v D="$dev" '
          $1==D {
            c++
            if (c==2) {
              printf "  IOPS snapshot: read=%.0f, write=%.0f ops/s\n", $4, $5
              printf "  Throughput   : read=%.1f MB/s, write=%.1f MB/s\n", $6, $7
            }
          }
        '
    } | tee "$report"

    echo "Report saved to $report"
}

# 1Password login

alias oplogin='tmux set-environment OP_SESSION_5VUOZKL7NZH4HJIUT6M4AYJT7I $(op signin --raw)'

# register kernel in conda env for jupyter
alias make_kernel=python -m ipykernel install --user --name $CONDA_DEFAULT_ENV --display-name "$CONDA_DEFAULT_ENV"

alias mm=micromamba

# local claude aliases
alias lcc='ANTHROPIC_AUTH_TOKEN=ollama ANTHROPIC_BASE_URL=http://localhost:11434 ANTHROPIC_API_KEY="" claude --model qwen3-coder'
alias lcl='ANTHROPIC_AUTH_TOKEN=ollama ANTHROPIC_BASE_URL=http://localhost:11434 ANTHROPIC_API_KEY="" claude --model qwen3:8b'

# add local configurations
if [ -f $HOME/.localrc ]; then source $HOME/.localrc; fi

# log the login
if [[ -n "$SSH_CLIENT" ]] && [[ -f $HOME/ssh_login_logger.sh ]]; then
        "$HOME/ssh_login_logger.sh"
fi

# runtime of a task of a specific PID:
pruntime() {
  emulate -L zsh
  set -o noglob

  if [[ $# -ne 1 ]]; then
    echo "Usage: pruntime <PID>" >&2
    return 2
  fi

  local pid="$1"

  if [[ ! -r "/proc/${pid}/stat" ]]; then
    echo "PID ${pid} not accessible (wrong user or it exited)" >&2
    return 1
  fi

  # Boot time + ticks per second
  local boot hertz ticks start now elapsed
  boot=$(awk '/btime/ {print $2}' /proc/stat) || return 1
  hertz=$(getconf CLK_TCK) || return 1
  ticks=$(awk '{print $22}' "/proc/${pid}/stat") || return 1
  start=$(( boot + ticks / hertz ))
  now=$(date +%s)
  elapsed=$(( now - start ))

  local days=$((elapsed/86400))
  local hh=$((elapsed%86400/3600))
  local mm=$((elapsed%3600/60))
  local ss=$((elapsed%60))

  # Stat fields
  local comm state utime stime vsize rss nice pri threads
  read _ comm state _ _ _ _ _ _ _ _ utime stime _ _ _ _ _ nice pri _ _ vsize rss _ _ _ _ _ threads _ <"/proc/${pid}/stat"
  comm=${comm//[()]/}

  # CPU time
  local cputime=$(((utime+stime)/hertz))
  local cdays=$((cputime/86400))
  local chh=$((cputime%86400/3600))
  local cmm=$((cputime%3600/60))
  local css=$((cputime%60))

  # Human-readable memory
  local pagesize=$(getconf PAGESIZE)
  local rss_bytes=$((rss * pagesize))
  local vsize_bytes=$vsize

  hr_kib() {
    # arg in kB (10^3 bytes), convert to KiB->MiB->GiB-ish display
    local kb=$1
    local kib=$(( kb * 1000 / 1024 ))  # approximate KiB; good enough for display
    local units=(KiB MiB GiB TiB)
    local i=0
    local val=$kib
    while (( val >= 1024 && i < ${#units[@]}-1 )); do
      val=$(( val / 1024 ))
      ((i++))
    done
    # print with one decimal – do simple fixed-point: val.x where x is next digit
    local next=$(( (kib * 100 / (1024 ** i)) % 100 ))
    printf "%d.%01d %s" "$val" $((next/10)) "${units[i]}"
  }

  local rss_h=$(hr_kib $rss_bytes)
  local vsize_h=$(hr_kib $vsize_bytes)

  # User & other info
  local user=$(stat -c %U "/proc/${pid}")
  local nfiles=$(ls -1 "/proc/${pid}/fd" 2>/dev/null | wc -l)
  local cgroup=$(awk -F: '/memory/ {print $3}' "/proc/${pid}/cgroup" 2>/dev/null)

  echo "PID:       $pid"
  echo "User:      $user"
  echo "Command:   $comm"
  echo "State:     $state"
  echo "Threads:   $threads"
  echo "Nice/Pri:  $nice / $pri"
  echo "Start:     $(date -d @${start})"
  printf "Elapsed:   %d days %02d:%02d:%02d\n" $days $hh $mm $ss
  printf "CPU time:  %d days %02d:%02d:%02d\n" $cdays $chh $cmm $css
  echo "Memory:    RSS=$rss_h VSZ=$vsize_h"
  echo "Open FDs:  $nfiles"
  [[ -n $cgroup ]] && echo "CGroup:    $cgroup"

  # Slurm hook
  if command -v scontrol >/dev/null 2>&1; then
    local jobid
    jobid=$(scontrol pidinfo "$pid" 2>/dev/null | awk -F= '/JobId/ {print $2}' | xargs)
    if [[ -n "$jobid" ]]; then
      echo "--- Slurm ---"
      echo "JobId:    $jobid"
      if command -v sacct >/dev/null 2>&1; then
        sacct -j "$jobid" --format=JobID,User,State,Start,Elapsed,End | sed 's/^/  /'
      fi
    fi
  fi
}

# net_by_user: per-UID Rx/Tx over a 1s window (or custom), tab-separated
# Usage:
#   net_by_user                # 1s, hide zeros
#   net_by_user 5              # 5s, hide zeros
#   net_by_user --all          # 1s, include zeros
#   net_by_user 10 --min 512   # 10s, hide totals < 512 B/s
# Notes:
# - Works without root on typical Linux (reads ss -i per-socket stats).
# - Aggregates TCP+UDP; sums bytes_received / bytes_acked per UID.
# - Prints per-user Rx/Tx in human-readable B/s, sorted by total.
net_by_user() {
  local interval="1" show_all=0 min_bps=0
  # tiny arg parser
  for a in "$@"; do
    case "$a" in
      --all) show_all=1 ;;
      --min) shift; min_bps="${1:-0}" ;;
      ''|*[!0-9]*) : ;;   # ignore non-numeric non-flags
      *) interval="$a" ;;
    esac
  done

  _nbu_snapshot() {
    # Emit: "<uid> <rx_bytes_total> <tx_bytes_total>"
    { ss -tein 2>/dev/null; ss -uein 2>/dev/null; } \
    | awk '
      function flush() {
        if (have_uid) { RX[uid]+=cur_rx; TX[uid]+=cur_tx }
        cur_rx=0; cur_tx=0; have_uid=0
      }
      /^[[:space:]]*$/ { flush(); next }
      /(^|[[:space:]])uid:[0-9]+/ {
        for (i=1;i<=NF;i++) if ($i ~ /^uid:/) { split($i,a,":"); uid=a[2]+0; have_uid=1 }
      }
      /bytes_acked:/ {
        for (i=1;i<=NF;i++) if ($i ~ /^bytes_acked:/) { split($i,a,":"); cur_tx += a[2]+0 }
      }
      /bytes_received:/ {
        for (i=1;i<=NF;i++) if ($i ~ /^bytes_received:/) { split($i,a,":"); cur_rx += a[2]+0 }
      }
      /^[A-Z]|^tcp|^udp/ { if (have_uid || cur_rx>0 || cur_tx>0) flush() }
      END { flush(); for (u in RX) printf "%d %lu %lu\n", u, RX[u]+0, TX[u]+0 }
    '
  }

  local s1 s2
  s1="$(_nbu_snapshot)"
  printf "Sampling per-user network usage for %ss...\n" "$interval" >&2
  sleep "$interval"
  s2="$(_nbu_snapshot)"

  # Combine snapshots with tags, then do all processing in one awk. Sort by total desc; strip key.
  {
    printf '%s\n' "$s1" | sed 's/^/S1 /'
    printf '%s\n' "$s2" | sed 's/^/S2 /'
  } | awk -v dt="$interval" -v show_all="$show_all" -v min_bps="$min_bps" '
    # Read passwd once to map uid->username
    BEGIN {
      while ( ("getent passwd" | getline line) > 0 ) {
        split(line, f, ":"); PW[f[3]] = f[1]
      }
      close("getent passwd")
    }
    # Human-readable binary units
    function human(n,   u) {
      if (n < 1024) return n "B/s"
      n/=1024; if (n < 1024) return sprintf("%.1fKiB/s", n)
      n/=1024; if (n < 1024) return sprintf("%.1fMiB/s", n)
      n/=1024;                 return sprintf("%.1fGiB/s", n)
    }
    # load snapshots
    /^S1 / {
      uid=$2+0; RX1[uid]=$3+0; TX1[uid]=$4+0; U[uid]=1; next
    }
    /^S2 / {
      uid=$2+0; RX2[uid]=$3+0; TX2[uid]=$4+0; U[uid]=1; next
    }
    END {
      for (u in U) {
        drx = (u in RX2 ? RX2[u] : 0) - (u in RX1 ? RX1[u] : 0); if (drx < 0) drx = 0
        dtx = (u in TX2 ? TX2[u] : 0) - (u in TX1 ? TX1[u] : 0); if (dtx < 0) dtx = 0
        rxps = drx / dt; txps = dtx / dt; tot = rxps + txps
        if (!show_all && tot <= 0) continue
        if (tot < min_bps) continue
        user = (u in PW ? PW[u] : u)
        # Stable, tab-separated, with a fixed-width numeric sort key first
        printf "%020.0f\t%s\tRX:%s\tTX:%s\n", tot, user, human(rxps), human(txps)
      }
    }' \
  | sort -r -n -k1,1 \
  | cut -f2- \
  | sed '/^[[:space:]]*$/d'   # paranoia: drop any empty line
}
