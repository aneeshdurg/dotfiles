function _check_run_alias
    pushd ~/src; and begin
        ./check_run.py -b $argv
        popd
    end
end

function _prot_try_alias
    pushd ~/src; and begin
        ./protocols/try $argv[1] -b $argv[2..-1]
        popd
    end
end

alias cr="_check_run_alias"
alias pt="_prot_try_alias"
alias b="build"
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
