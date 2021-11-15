# Enable color support of ls, dir, and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# LS aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Stop all Dockers
alias dockerstopall='docker stop $(docker ps -aq)'

# Redo command with root
alias please='sudo $(fc -ln -1)'

# Quick dir accesses
alias dev='cd ~/Development'
alias devlr='cd ~/Development/Li*'
alias devgh='cd ~/Development/Github/'

# Python
alias python='/usr/bin/python3'
alias pip='/usr/bin/pip3'

# SSH keep password
alias sshmem='ssh-add -t 120m ~/.ssh/id_rsa &>/dev/null; if [ "$?" == 2 ]; then eval `ssh-agent -s`; ssh-add -t 120m ~/.ssh/id_rsa; fi;'

# Update PHP alternatives
alias changephp='sudo update-alternatives --config php'

# Search history
alias histsrh='cat ~/.bash_history* | grep -i --color '

# Reboot sound system
alias soundreboot='pulseaudio -k && sudo alsa force-reload'

# Git quick
alias g='git'
