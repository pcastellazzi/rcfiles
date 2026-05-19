set -g __prompt_color_env purple
set -g __prompt_color_git yellow
set -g __prompt_color_pwd cyan
set -g __prompt_color_sql green

function __prompt_out
    set_color $argv[1]
    echo -ns $argv[2..]
    set_color normal
end

function __prompt_env
    set -l environment
    if set -q WSL_DISTRO_NAME
        set environment "wsl:$WSL_DISTRO_NAME"
    else if set -q AWS_ENVIRONMENT
        set environment "aws:$AWS_ENVIRONMENT"
    else
        set environment $hostname
    end
    __prompt_out $__prompt_color_env $environment
end

function __prompt_git
    set -l branch (git branch --show-current 2>/dev/null)
    if test $status -eq 0
        __prompt_out $__prompt_color_git "[$branch]"
    end
end

function __prompt_pwd
    set -l directory (prompt_pwd)
    __prompt_out $__prompt_color_pwd (prompt_pwd)
end

function __prompt_sql
    set -l database
    if set -q PGHOST
        set database "pgsql:$PGHOST"
        if set -q PGPORT
            set database "$database:$PGPORT"
        end
        if set -q PGDATABASE
            set database "$database/$PGDATABASE"
        end
        __prompt_out $__prompt_color_sql "$database"
    end
end

function __prompt_status
    for exit_code in $argv
        if test $exit_code -ne 0
            if test $exit_code -gt 128
                set -l sig_num (math $exit_code - 128)
                set -l sig_name (kill -l $sig_num)
                __prompt_out red "[$exit_code // SIG$sig_name]"
            else
                __prompt_out red "[$exit_code]"
            end
            break
        end
    end
end

function fish_prompt
    set -l last_status $status $pipestatus

    set -l lprompt (
        echo -en \
            (__prompt_env) \
            (__prompt_pwd) \
            (__prompt_git) \
            (__prompt_status $last_status)
    )
    set -l rprompt (
        echo -en \
            (__prompt_sql)
    )

    set -l lprompt_length (string length --visible "$lprompt")
    set -l rprompt_length (string length --visible "$rprompt")
    set -l padding (math $COLUMNS - $lprompt_length - $rprompt_length)

    if test $padding -gt 0
        printf "%s%*s%s\n❯ " "$lprompt" $padding "" "$rprompt"
    else
        printf "%s\n❯ " "$lprompt"
    end
end
