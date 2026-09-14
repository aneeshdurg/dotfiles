---
name: neovim-panes
description: Use when the user asks to open a file, or run a command, in a new split/window/pane/tab of their editor — e.g. "open X in a split", "show me Y in a new tab", "run the tests in a vertical split", "pop open a terminal and run Z". Only applies when the user is running their shell inside Neovim (check for a live server first) and has `nvr` (neovim-remote) installed.
---

# Neovim panes via nvr

The user runs their shell inside Neovim and uses `nvr` (neovim-remote) to control
that Neovim instance from the shell. This lets you open files or run commands in a
new split/tab of their *existing* editor session instead of just printing output
in the terminal.

## Precondition

Before using this, confirm a Neovim server is reachable:

```sh
nvr --serverlist
```

If this prints nothing (or `nvr` isn't installed), don't attempt any of the below —
just fall back to normal terminal output. `nvr` targets the socket in `$NVIM` (set
automatically inside a Neovim `:terminal`) or `/tmp/nvimsocket` by default; only
pass `--servername <addr>` explicitly if the user is targeting a different
instance than the one their shell is inside.

## Opening a file

| Where          | Command                  |
|----------------|---------------------------|
| Horizontal split | `nvr -o <file>`         |
| Vertical split  | `nvr -O <file>`          |
| New tab         | `nvr -p <file>`          |

Multiple files can be passed to any of these; each gets its own split/tab.

## Running a command in a terminal

There's no dedicated flag for this — use `-cc` to run a Vim command before
opening, combining a window/tab command with `:terminal`:

- Horizontal split: `nvr -cc "split | terminal <cmd>"`
- Vertical split: `nvr -cc "vsplit | terminal <cmd>"`
- New tab: `nvr -cc "tabe | terminal <cmd>"`

Example — run the test suite in a new vertical split:

```sh
nvr -cc "vsplit | terminal npm test"
```

**Exception: any `sudo` command, even a single-line one, skips this section entirely
and goes straight to the scratch script pattern below.** Don't reach for
`nvr -cc "split | terminal sudo <cmd>"` just because the command is short — the
scratch script pattern is what makes the password prompt and command echo behave
correctly, and that need doesn't depend on line count.

### Escaping caveat

`:terminal` in Vim treats an unescaped `|` in the command as a Vim command
separator, not part of the shell command. If `<cmd>` itself contains a `|`
(a shell pipe), escape it as `\|`, e.g.:

```sh
nvr -cc 'vsplit | terminal ls -la \| wc -l'
```

For anything with heavier quoting/pipes/redirection, it's simpler to wrap it in
`sh -c '...'`:

```sh
nvr -cc "vsplit | terminal sh -c 'ls -la | wc -l'"
```

### Multi-line or sensitive commands: scratch script pattern

Use this pattern whenever any of the following is true — **any one of them is
sufficient on its own**, not just "the command is long":
- it involves `sudo` (regardless of whether it's one line or several)
- it's several commands rather than one
- the user should watch it execute interactively rather than just see the output

Don't try to cram these into the `-cc` string. Instead:

1. Pick a unique scratch path with `mktemp` (e.g. `mktemp /tmp/nvr-cmd.XXXXXX.sh`)
   — never reuse a fixed name like `/tmp/blah.sh`, since a concurrent or later
   invocation of this same pattern would clobber it mid-run.
2. `Write` the commands to that path, with `rm -f <path>` as the *last* line so
   the script deletes itself once done.
3. Open it with `nvr -cc split --remote-wait "term://bash -ix <path>"` — `-i`
   makes bash prompt-echo each command as it runs (so the user watches it happen
   live, including `sudo` password prompts if needed), `-x` additionally traces
   expanded commands. Using `term://` (instead of `terminal`) together with
   `--remote-wait` makes the `nvr` invocation itself **block** until the script's
   process exits, so the Bash tool call doesn't return until the user's script is
   actually done — this is what lets you know the script finished instead of
   guessing or polling.

```sh
tmp=$(mktemp /tmp/nvr-cmd.XXXXXX.sh)
cat > "$tmp" <<EOF
sudo systemctl restart foo
sudo journalctl -u foo -n 20
rm -f $tmp
EOF
nvr -cc split --remote-wait "term://bash -ix $tmp"
```

This is the go-to pattern any time you need the user to run something you can't
run yourself (e.g. a scoped sudo grant that doesn't cover this specific command) —
write it once, hand it to their live editor to execute, no re-typing or copy-paste
errors, and no leftover script file afterward. Because the call blocks until the
process exits, you'll be notified the moment it completes rather than having to
ask the user or poll.

## Notes

- These commands act on the user's live Neovim session — the new split/tab will
  actually appear on their screen. Prefer this over plain shell output when the
  user is asking to "see"/"open"/"pop up" something, not just wants the output
  text back in the response.
- Don't open panes speculatively for every command you run — only when the user
  asks for it, or it's clearly the point of the request (e.g. "open the diff in a
  split so I can look at it").
