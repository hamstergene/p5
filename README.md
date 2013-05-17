# `p5` : commands missing from Perforce's `p4`

This script provides three commands I have been always missing from Perforce command-line utilities.

    usage: p5 [-h] {status,st,reconcile,re,diff,di} ...

    positional arguments:
      {status,st,reconcile,re,diff,di}
                            Commands
        status (st)         Shows status of workspace files (changed, missing,
                            etc)
        reconcile (re)      Interactively reconcile changes.
        diff (di)           Show diff, including unopened files.

    optional arguments:
      -h, --help            show this help message and exit

## Commands

### `p5 reconcile`

Interactive reconcile. Uses `$EDITOR` environment variable for user interaction, which defaults to `vi`.

### `p5 status`

Works similar to `git status`: prints list of changed files in the workspace, including edited but unopened ones.

### `p5 diff`

Shows combined diff, including unopened files that were modified.

## Ignoring files with `.p4ignore`

If the workspace root contains `.p4ignore` file, it will be used. The format is similar to `.gitignore`:

* One pattern per line.
* If pattern does not contain '/', it matches filename only.
* If pattern has '/', it matches paths, relative to the workspace root.
* Patterns are matched using `fnmatch` (supports `*` wildcards).
* `.p4ignore` and `$P4CONFIG` files are not ignored by default. You have to add them manually if you need that.

## Misc

This program depends on `python3` and `p4`.

    brew install python3 p4

