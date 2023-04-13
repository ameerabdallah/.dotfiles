#!/usr/bin/env bash
languages=$(echo "golang lua cpp c typescript nodejs" | tr ' ' '\n')
core_utils=$(echo "xargs find mv sed awk grep tmux" | tr ' ' '\n')

selected=$(printf '%s\n%s' "$languages" "$core_utils" | sort | fzf)
echo "$selected"
if [ -z "$selected" ]; then
  exit 0
fi
read -r -p "query: " query

if printf '%s' "$core_utils" | grep -q "$selected"; then
  tmux neww bash -c "curl cht.sh/$selected~\"$query\" & while true; do sleep 1; done"
else
  tmux neww bash -c "curl cht.sh/$selected/$(echo "$query" | tr ' ' '+') & while true; do sleep 1; done"
fi
