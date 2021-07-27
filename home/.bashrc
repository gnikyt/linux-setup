#!/usr/bin/env bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

#################################
# HISTORY FILE
#################################

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT="%F %T "

# Add history to current session
export PROMPT_COMMAND='history -a; history -r;'

#################################
# FUNCTIONS
#################################

# Get current status of git repo
function parse_git_dirty {
	status=$(git status 2>&1 | tee)
	dirty=$(echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?")
	untracked=$(echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?")
	ahead=$(echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?")
	newfile=$(echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?")
	renamed=$(echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?")
	deleted=$(echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?")
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

# Get current branch in git repo
function parse_git_branch() {
	BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=$(parse_git_dirty)
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# Pomodo timer
# Example: `promo 5 Take a Break`
# Result: Plays sound and shows notification.
function pomo() {
    arg1=$1
    shift
    args="$*"

    min=${arg1:?Example: pomo 15 Take a break}
    sec=$((min * 60))
    msg="${args:?Example: pomo 15 Take a break}"

    while true; do
        sleep "${sec:?}" && for _ in {1..2}; do ogg123 /usr/share/sounds/gnome/default/alerts/sonar.ogg &> /dev/null; done && notify-send -u critical -t 0 "${msg:?}"
    done
}

# History backup
# Example: `histbkup`
# Result: will create a `.bash_history.[YYYY]_[MM]`
function histbkup() {
	KEEP=200
	BASH_HIST=~/.bash_history
	BACKUP="$BASH_HIST".$(date +%Y_%m)

	# History file is newer then backup
	if [ -f "$BACKUP" ]; then
	# There is already a backup
	cp -f "$BASH_HIST" "$BACKUP"
	else
	# Create new backup, leave last few commands and reinitialize
	mv -f "$BASH_HIST" "$BACKUP"
	tail -n "$KEEP" "$BACKUP" > "$BASH_HIST"
	history -r
	fi
}

# CD to show a list when switching
# Example: `cd ..`
# Result: Directory changed, directory listed
function cd() {
    builtin cd "$@" && ls -lA --color
}

# Move 'up' so many directories instead of using several cd ../../, etc.
# Example: `up 3`
# Result: Moves up 3 directories
function up() {
	cd $(eval printf '../'%.0s {1..$1}) && pwd;
}

#################################
# MISC VARS
#################################

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#################################
# PROMPT
#################################

# Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    PS1="\[\e[36m\]\u\[\e[m\]@\[\e[32m\]\h\[\e[m\]:\[\e[35m\]\W\[\e[m\] \[\e[34m\]\`parse_git_branch\`\[\e[m\]\[\e[33m\][\[\e[m\]\[\e[33m\]\t\[\e[m\]\[\e[33m\]]\[\e[m\] "
else
    PS1="\u@\h:\W \`parse_git_branch\`[\A] "
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

#################################
# ALIASES & COMPLETION
#################################

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#################################
# PATH
#################################

export GEM_HOME=$HOME/.gems
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# NPM packages
if [ -d "$HOME/.npm-packages" ] ; then
    NPM_PACKAGES="${HOME}/.npm-packages"
    PATH="$NPM_PACKAGES/bin:$PATH"
fi

# Gem packages
if [ -d "$GEM_HOME" ] ; then
    PATH="$GEM_HOME/bin:$PATH"
fi
