#!/usr/bin/env bash

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

#################################
# LOCALES
#################################

export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

#################################
# SOURCING
#################################

. $HOME/.config/bash/history
. $HOME/.config/bash/functions
. $HOME/.config/bash/misc
. $HOME/.config/bash/prompt
. $HOME/.config/bash/aliases
. $HOME/.config/bash/paths
. $HOME/.config/bash/autocomplete

. "$HOME/.cargo/env"
