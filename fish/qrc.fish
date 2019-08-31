function _check_run_alias
    pushd ~/src; and begin
        ./check_run.py -b $argv
        popd
    end
end

alias cr="_check_run_alias"
alias b="build"
