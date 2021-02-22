#!/usr/bin/env sh
# Reads dir structure of repo, copies based on path.
# Usage:
#   ./update.sh
# Usage (dry run):
#   DRY_RUN=1 ./update.sh

dry_run=${DRY_RUN:-0}
result=$(find . -not -path './.git/*' -not -path './.git' -not -path './README.md' -not -path './update.sh')

for path in $result
do
    if [ "$path" != "." ] && [ -f "$path" ]; then
        start=$(echo "$path" | cut -c3)
        if [ "$start" = "." ]; then
            fixed_path=$(echo "$path" | sed -e "s#./.#/home/$USER/.#")
        else
            fixed_path=$(echo "$path" | sed -e "s#./#/#")
        fi

        echo "$fixed_path" ">" "$path"
        
        if [ "$dry_run" = 0 ]; then
            cp "$fixed_path" "$path"
        fi
    fi
done
