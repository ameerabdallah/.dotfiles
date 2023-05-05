#!/bin/zsh

source ~/.git-prompt.sh
setopt prompt_subst

autoload -U add-zsh-hook

add-zsh-hook precmd __git_ps1
add-zsh-hook precmd update_current_git_vars

function update_current_git_vars () {
    GIT_AHEAD=$(get_git_ahead)
    GIT_BEHIND=$(get_git_behind)
    GIT_BRANCH=$(changes_in_branch)
    add_git_vars_to_prompt
}

function changes_in_branch() {
    value=""
    if git rev-parse --git-dir > /dev/null 2>&1; then
        if [ -n "$(git status -s)" ]; then
            value="%{%F{yellow}%}$(__git_ps1)%{%f%}"
        else
            value="%{%F{green}%}$(__git_ps1)%{%f%}"
        fi
    fi
    echo -n $value
}

function get_git_ahead() {
    value=$(git rev-list --left-right --count HEAD...@{u} 2> /dev/null | awk '{print $1}')
    if [[ "0" == "$value" || -z "$value" ]]; then
        value=""
    else
        value=" +$value"
    fi
    echo -n "$value"
}

function get_git_behind() {
    value=$(git rev-list --left-right --count @{u}...HEAD 2> /dev/null | awk '{print $1}')
    if [[ "0" == "$value" || -z "$value" ]]; then
        value=""
    else
        value=" -$value"
    fi
    echo -n "$value"
}

function add_git_vars_to_prompt() {
    PROMPT="%{%F{red}%}%n%{%f%}"
    PROMPT+="%{%F{white}%}:%{%f%}"
    PROMPT+="%{%F{cyan}%}%~%{%f%}"
    PROMPT+="${GIT_BRANCH}"
    PROMPT+="%{%F{red}%}${GIT_BEHIND}%{%f%}"
    PROMPT+="%{%F{green}%}${GIT_AHEAD}%{%f%}"$'\n'
    PROMPT+="%{%F{green}%}└─ %{%F{yellow}%}\$ %{%f%}"
}

