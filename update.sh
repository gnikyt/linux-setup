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
    # Ignore "." and ignore if not an actual file
    if [ "$path" != "." ] && [ -f "$path" ]; then
        if echo "$path" | grep -q "home"; then
            # Path starts with ".", assume its a hidden file from home directory
            fixed_path=$(echo "$path" | sed -e "s#./home/#/home/$USER/#")
        else
            # Path is somewhere else on the system besides home
            fixed_path=$(echo "$path" | sed -e "s#./#/#")
        fi

        # Show what will be copied
        echo "$fixed_path" ">" "$path"

        if [ "$dry_run" = 0 ]; then
            # Do the copy if not a dry run
            cp "$fixed_path" "$path"
        fi
    fi
done
