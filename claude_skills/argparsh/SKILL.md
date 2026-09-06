---
name: argparsh
description: Use whenever writing or editing a bash/shell script that needs to parse command-line arguments/flags/options (positional args, -flag/--flag options, subcommands). The user prefers argparsh (a Rust CLI that embeds python's argparse) over hand-rolled getopts/case-block parsing. Check `command -v argparsh` first; if missing, install with `cargo install argparsh` or fall back to a manual parser and say so.
---

# argparsh

`argparsh` builds an argument parser by piping a sequence of `argparsh <subcommand>`
calls (each emits an encoded fragment) into `argparsh parse`, which evaluates the
parsed result back into shell variables. It's a thin wrapper around Python's
`argparse`, so its semantics (types, `nargs`, subparsers, choices, required/default,
help text) match argparse exactly.

Precondition: check `command -v argparsh`. If it's missing, either install it
(`cargo install argparsh`) or tell the user it's unavailable and fall back to plain
`getopts`/case-block parsing — don't silently write a manual parser when the point
was to use argparsh.

## Core shape

```sh
parser=$({
    argparsh new "$0" -d "Description of the script" [-e "epilog text"]
    argparsh add_arg [OPTIONS] -- [aliases...]
    # ... more add_arg calls ...
})

eval $(argparsh parse "$parser" -- "$@")

# parsed values are now shell variables, named after the dest
echo "$myarg"
```

- Everything that builds the parser goes inside `$({ ... })` — each `argparsh`
  subcommand appends an encoded fragment to `$parser`.
- `--` in `add_arg` separates the *options* (type, default, help...) from the
  *aliases* being registered. Omit aliases (or start with a non-`-` token) for a
  positional argument.
- `argparsh parse ... -- "$@"` must be run through `eval` — that's what actually
  defines the shell variables (or associative array / JSON, see Output formats).
- Argument `-h`/`--help` and errors are handled automatically by argparse; on
  help/parse-failure, `parse` prints `exit <code>` to stdout and you're expected to
  `eval` that too (it's part of the same eval'd blob) so the script exits with the
  right code.

## `add_arg` — the options that matter most

Run `argparsh add_arg --help` for the full list. Frequently used ones:

| Flag | Meaning |
|---|---|
| `--helptext "..."` | Help string for `-h` output |
| `--type int\|float\|str\|...` | Validates/coerces the value |
| `--default VALUE` | Default if argument absent |
| `-r`, `--required` | Marks a flag argument required |
| `-a`, `--action store\|store_true\|append\|count\|help` | Behavior on match; `store_true` for boolean flags |
| `-c`, `--choice X` (repeatable) | Restrict to an enum of values |
| `-n`, `--nargs-exact N` / `--nargs +\|*` | Consume N / at-least-one / any-number of values |
| `--dest NAME` | Override the shell variable name (default inferred from alias) |
| `--metavar NAME` | Display name in usage/help text |

Positional example:
```sh
argparsh add_arg --helptext "Input file" -- infile
```

Flag example (`-i`/`--intarg`, typed, with a default):
```sh
argparsh add_arg --helptext "Interval" --type int --default 10 -- -i --intarg
```

Boolean flag:
```sh
argparsh add_arg --action store_true -- -f --force
```

## Subcommands

```sh
parser=$({
    argparsh new "$0"
    argparsh add_subparser mycmd --required   # subparser group, dest defaults to "mycmd"
    argparsh add_subcommand foo                # <prog> foo
    argparsh add_subcommand bar                # <prog> bar

    # arguments scoped to one subcommand need --subcommand (and --subparserid
    # if more than one subparser group exists)
    argparsh add_arg --subcommand foo -- qux
    argparsh add_arg --subcommand bar -- baz
})
eval $(argparsh parse "$parser" -- "$@")
```

`set_defaults --subcommand <name> KEY=VALUE...` attaches fixed key/value pairs to a
specific subcommand branch (handy for dispatch: give each subcommand a distinct
default and branch on it after parsing). Sub-subparsers are supported via
`--parent-subparserid`/nesting `add_subparser` calls — see
`argparsh add_subparser --help` for the full nested example.

## Output formats

`argparsh parse` defaults to `--format shell` (plain `KEY=VALUE` vars). Other
formats, still consumed via `eval`:

- `--format shell --prefix arg_` — prefix all variable names (avoids clobbering)
- `--format shell -e`/`--export` — export as environment variables
- `--format shell -l`/`--local` — declare as `local` (bash/zsh functions)
- `--format assoc-array --name args` — populate an associative array `$args[...]`
  instead of separate variables
- `--format json` — emit parsed args as JSON (for piping to `jq` etc., not eval'd)

## Reference

Full worked examples live in the argparsh repo's `examples/` directory
(`example.sh`, `subsubparsers.sh`, `stopwatch.sh`, `inafunction.sh`) and the
per-subcommand `--help` text (`argparsh new|add_arg|add_subparser|add_subcommand|
set_defaults|parse --help`) is authoritative for flags not covered above.
