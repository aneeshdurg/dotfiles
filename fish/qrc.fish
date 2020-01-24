function relativize
    for arg in $argv
        # need to prepand a . before strings to prevent string from percieving
        # them as arguments.
        if test (string sub -l 2 "."$arg) = ".-"
            echo $arg
        else
            set -l split (string split ':' $arg)
            set path (realpath --relative-base (hg root) $split[1])
            string join ':' $path $split[2..-1]
        end
    end
end

function _check_run_alias
    set rel_args (relativize $argv)
    pushd ~/src; and begin
        ./check_run.py -b $rel_args
        popd
    end
end

function _prot_try_alias
    set server $argv[1]
    set rel_args (relativize $argv[2..-1])
    pushd ~/src; and begin
        ./protocols/try $server -b $rel_args
        popd
    end
end

function _red_green_alias
    set rel_args (relativize $argv)
    pushd ~/src; and begin
        ./tools/red_green.py $rel_args
        popd
    end
end

function _build_alias
    set rel_args (relativize $argv)
    pushd ~/src; and begin
        build $rel_args
        popd
    end
end

alias crg="_red_green_alias"
alias cr="_check_run_alias"
alias pt="_prot_try_alias"
alias b="_build_alias"
alias gh="hg"
function hgq
    eval hg q"$argv"
end

function get_last_smb_port
        cat /home/adurg/src/build/tmp/latest/**/debug.log |\
        grep "SMB.*127" |\
        head -n1 |\
        rev |\
        cut -d: -f1 |\
        rev |\
        tr -d '\n'|\
        tee /tmp/smb2_last_port |\
        xclip -i -selection "clipboard"

        echo "Copied port "(cat /tmp/smb2_last_port)" to clipboard"
end

function hgqq
    hg qpop -a; and hg qq $argv[1]; and hg q;
end

function replace
    if test (count $argv) -ne 2
        echo "replace only takes 2 argument!"
    else
        set escaped1 (string replace -a '/' '\\/' $argv[1])
        set escaped2 (string replace -a '/' '\\/' $argv[2])
        ag $argv[1] -l | xargs -I% sed -i "s/$escaped1/$escaped2/" %
    end
end
