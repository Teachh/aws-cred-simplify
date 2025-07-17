#!/bin/bash

CREDENTIALS="$HOME/.aws/credentials"

manage_default(){
    line_default=$(grep -n '^\[default\]$' "$CREDENTIALS" | cut -d: -f1)
    if [ -n "$line_default" ]; then
        line_above=$((line_default - 1))
        above_content=$(sed -n "${line_above}p" "$CREDENTIALS")
        if [[ "$above_content" =~ ^# ]]; then
            echo "📢 Found commented section above [default], decommenting and deleting [default]"
            echo "" 
            sed -i "${line_above}s/^#\s*//" "$CREDENTIALS"
            sed -i "${line_default}d" "$CREDENTIALS"
        else
            num=$((1 + RANDOM % 1000))
            echo "📢 [default] exists in file, renaming it it [default-old-$num]"
            sed -i "s/^\[default\]/[default-old-$num]/" "$CREDENTIALS"
        fi
    fi
}

select_profile(){
    mapfile -t envs < <(grep '^\[.*\]$' "$CREDENTIALS")
    echo "🎨 Available profiles:"
    for i in "${!envs[@]}"; do
        printf "%d) %s\n" "$((i+1))" "${envs[$i]}"
    done
    echo ""
    read -rp "🛠️  Select a profile by number: " choice
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#envs[@]} )); then
        echo "Invalid selection."
        exit 1
    fi
    SELECTED="${envs[$((choice-1))]}"
    echo "✨ You selected: $SELECTED"
}

change_default(){
    escaped_selected=$(printf '%s\n' "$1" | sed 's/[]\/$*.^[]/\\&/g')
    sed -i "/^$escaped_selected\$/ {
        s/^/# /
        a\\[default]
    }" "$CREDENTIALS"
}

if [ -e $CREDENTIALS ]; then
    
    # How [default] is managed
    manage_default

    # Select AWS profile
    select_profile

    # Modify file commenting the previous one and adding the [default]
    change_default $SELECTED
    
else
    echo "⛔ Credentials file does not exists in ~/.aws/credentials"
fi