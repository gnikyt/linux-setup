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

        # Show what will be symlinked
        printf "############################################\n# ln -s %s %s\n############################################" "$path" "$fixed_path"

        if [ "$dry_run" = 0 ]; then
            # Do the symlink, if not a dry run
            if [ -L "$fixed_path" ]; then
                echo ">> Link name exist, delete the link first and try again? (Y/N) "
                read -r answer
                if [ "$answer" != "${answer#[Yy]}" ] ;then
                    sudo rm -i "$fixed_path"s
                    ln -s "$path" "$fixed_path"
                fi
            else
                ln -s "$path" "$fixed_path"
                rm "$fixed_path"
            fi
        fi
    fi
done
