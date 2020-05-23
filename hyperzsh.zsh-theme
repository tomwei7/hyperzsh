# vim:et sts=2 sw=2 ft=zsh
#
# Gitster theme
# https://github.com/shashankmehta/dotfiles/blob/master/thesetup/zsh/.oh-my-zsh/custom/themes/gitster.zsh-theme
#
# Requires the `git-info` zmodule to be included in the .zimrc file.

_prompt_gitster_pwd() {
  local git_root current_dir
  if git_root=$(command git rev-parse --show-toplevel 2>/dev/null); then
    current_dir="${PWD#${git_root:h}/}"
  else
    current_dir="${PWD/#${HOME}/~}"
  fi
  print -n "%F{white}${current_dir}"
}

setopt nopromptbang prompt{cr,percent,sp,subst}

typeset -gA git_info
if (( ${+functions[git-info]} )); then
  zstyle ':zim:git-info:branch' format '%b'
  zstyle ':zim:git-info:commit' format '%c'
  zstyle ':zim:git-info:clean' format '%F{green}✓'
  zstyle ':zim:git-info:dirty' format '%F{yellow}✗'
  zstyle ':zim:git-info:keys' format \
      'prompt' ' %F{cyan}%b%c %C%D'

  autoload -Uz add-zsh-hook && add-zsh-hook precmd git-info
fi

function _user_host() {
  if [[ -z ${SSH_TTY} ]]; then
      return
  fi
  if [[ $(whoami) =~ \([-a-zA-Z0-9\.]+\) ]]; then
    me="%n@%m"
  elif [[ logname != $USER ]]; then
    me="%n"
  fi
  if [[ -n $me ]]; then
    echo "%F{cyan}$me "
  fi
}

function _python_venv() {
  if [[ $VIRTUAL_ENV != "" ]]; then
    echo "%F{blue}(${VIRTUAL_ENV##*/})"
  fi
}

function _proxy_status() {
    if [[ $HTTP_PROXY != "" || $http_proxy != "" ]]; then
        echo "%F{green}☷ "
    fi
}

local _background_job="%F{blue}%(1j.⟳ %j .)"

PS1='$(_python_venv)$(_proxy_status)${_background_job}$(_user_host)%(?:%F{green}:%F{red})λ $(_prompt_gitster_pwd)${(e)git_info[prompt]}%f '
unset RPS1
