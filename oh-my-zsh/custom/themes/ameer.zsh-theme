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
    if expr "$(git status -s)" 2>&1 >  /dev/null; then
      value="%{${fg[yellow]%}$(__git_ps1)%{$reset_color%}"
    else
      value="%{${fg[green]%}$(__git_ps1)%{$reset_color%}"
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
  PROMPT="%{$fg_bold[red]%}%n%{$reset_color%}"
  PROMPT+="%{$fg[white]%}:%{$reset_color%}"
  PROMPT+="%{$fg_bold[cyan]%}%~%{$reset_color%}"
  PROMPT+="${GIT_BRANCH}"
  PROMPT+="%{%F{red}%}${GIT_BEHIND}%{$reset_color%}"
  PROMPT+="%{%F{green}%}${GIT_AHEAD}%{$reset_color%}"$'\n'
  PROMPT+="%{$fg_bold[green]%}└─ %{$fg_bold[yellow]%}\$ %{$reset_color%}"
}

