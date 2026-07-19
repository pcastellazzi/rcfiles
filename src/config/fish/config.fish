status is-interactive; or return

# sudo launchctl config user umask 077
# sudo chfn -o other='umask=077'
if test $umask != '0077'
    echo >&2 "[WRN] default umask is $umask. Forcing 0077."
    umask 0077
end

set -gx COPIER_SETTINGS_PATH '~/.config/copier/settings.yml'
set -gx EDITOR 'vim'
set -gx FZF_DEFAULT_COMMAND 'fd --type=file --hidden --follow'
set -gx LANG 'en_US.UTF-8'
set -gx LC_ALL 'en_US.UTF-8'
set -gx PAGER 'bat'

set -e -Ugl PATH
fish_add_path --path --append /usr/local/bin /usr/bin /bin /usr/local/sbin /usr/sbin /sbin

set -e -Ugl fish_user_paths
fish_add_path (path resolve ~/.local/bin ~/bin)

set -l brew_bin brew
switch (uname)
case Darwin
    set brew_bin /usr/local/bin/brew
case Linux
    set brew_bin /home/linuxbrew/.linuxbrew/bin/brew
end

cache_config $brew_bin shellenv
cache_config batman --export-env
cache_config fzf --fish
cache_config zoxide init fish

alias cat=bat
alias ls="eza --classify=auto --color=auto --icons=auto"

if test -f ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end
