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
# SOURCING
#################################

. $HOME/.config/bash/history
. $HOME/.config/bash/functions
. $HOME/.config/bash/misc
. $HOME/.config/bash/prompt
. $HOME/.config/bash/aliases
. $HOME/.config/bash/autocomplete
. $HOME/.config/bash/paths
