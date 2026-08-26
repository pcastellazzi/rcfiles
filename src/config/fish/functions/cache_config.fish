function cache_config
    if test (count $argv) -lt 1
        echo "Error: cache_shellenv requires at least a command name." >&2
        return 1
    end

    set -l cmd $argv[1]
    set -l bin_path (type -p $cmd)
    set -l bin_name (basename $bin_path)

    if test -z "$bin_path"
        echo "Error: Command '$cmd' not found in PATH" >&2
        return 1
    end

    set -l cache_dir $__fish_config_dir/cache.d
    set -l cache_file $cache_dir/$bin_name.fish

    mkdir -p $cache_dir
    if test $bin_path -nt $cache_file
        $bin_path $argv[2..] >$cache_file
    end

    source $cache_file
end
