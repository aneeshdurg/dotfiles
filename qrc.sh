_check_run_alias() {
    pushd ~/src && {
        ./check_run.py -b $@
        popd
    }
}
alias cr="_check_run_alias"
alias b="build"
