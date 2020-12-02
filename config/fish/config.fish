#!/usr/bin/env fish

if status --is-login
  set -gx PATH /usr/local/bin /usr/bin /bin /usr/local/sbin /usr/sbin /sbin
  set -gx EDITOR '/usr/bin/vim'
  set -gx PAGER '/usr/bin/less'
  set -gx LC_ALL 'en_US.UTF-8'
  set -gx LANG 'en_US.UTF-8'
  umask 0077
end

if test -f ~/.config/fish/fish_local
  . ~/.config/fish/fish_local
end
