eval (/opt/homebrew/bin/brew shellenv)

set -gx PATH /Users/aneesh/nvim-macos/bin/ $PATH
set -gx PATH /Users/aneesh/jdtls/bin/ $PATH

# Generated for envman. Do not edit.
test -s "$HOME/.config/envman/load.fish"; and source "$HOME/.config/envman/load.fish"

################################################################################
#  _ ____   ___ __ ___
# | '_ \ \ / / '_ ` _ \
# | | | \ V /| | | | | |
# |_| |_|\_/ |_| |_| |_|
# figlet: nvm
################################################################################
function nvm
   bass source (brew --prefix nvm)/nvm.sh --no-use ';' nvm $argv
end

set -x NVM_DIR ~/.nvm
nvm use default --silent
################################################################################

################################################################################
#  _               _
# | |__   ___   __| | ___
# | '_ \ / _ \ / _` |/ _ \
# | |_) | (_) | (_| | (_) |
# |_.__/ \___/ \__,_|\___/
# figlet: bodo
################################################################################
# Enable detailed error messages for local development
set -x NUMBA_DEVELOPER_MODE 1
# Disable Python buffering
set -x PYTHONBUFFERED 1

function b
  pushd (git rev-parse --show-toplevel )
  env BODO_FORCE_COLORED_BUILD=1 python3 setup.py develop &| tee error.errs
  set retval $pipestatus[1]
  popd
  return $retval
end
function bsql
  pushd (git rev-parse --show-toplevel )/BodoSQL
  env BODO_FORCE_COLORED_BUILD=1 python setup.py develop &| tee ../error_bsql.errs
  set retval $pipestatus[1]
  popd
  return $retval
end

function sg
  pushd (git rev-parse --show-toplevel )
  ag \
    --ignore BodoSQL/calcite_sql/bodosql-calcite-application/src/test/resources/com/bodosql/calcite/application/_generated_files/ \
    --ignore BodoSQL/calcite_sql/bodosql-calcite-application/src/test/resources/com/bodosql/calcite/application/table_schemas/ \
    $argv
  popd
end
################################################################################
