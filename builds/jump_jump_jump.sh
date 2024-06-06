#!/bin/sh
echo -ne '\033c\033]0;Jump Jump Jump\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/jump_jump_jump.x86_64" "$@"
