# `p5` : commands missing from Perforce's `p4`

This script provides a few commands I miss from Perforce command-line utilities.

    usage: p5 [-h] [--version]
              {checkout,co,status,st,update,up,reconcile,re,diff,di} ...

    positional arguments:
      {checkout,co,status,st,update,up,reconcile,re,diff,di}
                            Commands
        checkout (co)       Create workspace and fetch files.
        status (st)         Show local changes, including unopened files that were
                            changed/added/removed.
        update (up)         Update client view with the latest clientspec mappings
                            then sync.
        reconcile (re)      Interactive reconcile
        diff (di)           Show diff, including unopened files.

    optional arguments:
      -h, --help            show this help message and exit
      --version             show program's version number and exit

## Commands

### `p5 checkout`

Creates workspace from given clientspec mappings file and fetches files.

    usage: p5 checkout [-h] [-c workspace] clientspec_path [@changelist]

    Creates workspace in the current directory from given clientspec mappings
    file, and syncs.

    positional arguments:
      clientspec_path       Depot path or local path to the client workspace
                            mappings file. The value is saved into P5CLIENTSPEC
                            variable and is used later by `update`, `reconcile`
                            and other commands.
      @changelist           Sync to this changelist number. Defaults to the most
                            recent changelist.

    optional arguments:
      -h, --help            show this help message and exit
      -c workspace, --client workspace
                            Set P4CLIENT for the new workspace. Defaults to
                            `${P4USER}-$(basename $PWD)` (for example, is user
                            name is `john_d` and current directory is
                            `~/Documents/NewProj`, the default workspace name is
                            `john_d-NewProj`). The value is saved into P4CLIENT
                            variable and will be used by all perforce tools (`p4`
                            and `p5` both).

Clientspec path and workspace name are automatically saved into `P4CONFIG` (`.perforce`) for future use with `p5 update` and `p5 reconcile`:

    # $WORKSPACE_ROOT/.perforce

    P4CLIENT=current-workspace-name
    P5CLIENTSPEC=//depot/path/to/client_view_definition.txt

### `p5 reconcile`

Interactive reconcile. Uses `$EDITOR` environment variable for user interaction, which defaults to `vi`. Works much much much faster than P4V's one and respects `.p4ignore`. It is also much more comfortable to use than builtin `p4 reconcile`, and is available even with old Perforce servers.

### `p5 status`

Works similar to `git status`: prints list of changed files in the workspace, including edited but unopened ones.

### `p5 diff`

Shows combined diff similar to `p4 diff`, but including unopened files that were modified.

### `p5 update`

Updates workspace if necessary, then runs `p4 sync`.

    usage: p5 update [-h] [-f] [-n] [@changelist]

    positional arguments:
      @changelist    Sync to this changelist number. Defaults to the most recent
                     changelist.

    optional arguments:
      -h, --help     show this help message and exit
      -f, --force    Pass `-f` to `p4 sync`
      -n, --dry-run  Preview what would be done.

If `P5CLIENTSPEC` is a local file, the view mappings are read from that file. If it is an opened depot file, the view mappings are read from current local copy that file. Otherwise, the clientspec mappings are fetched from the depot (for the given changelist if given). Then the current workspace is updated and `p4 sync` is invoked. If `-n` flag is present, the workspace is reverted back when the command is done.

## Installation/Configuration

There is Homebrew formula for easy installation/upgrade on OS X:

    brew install https://raw.githubusercontent.com/hamstergene/p5/master/homebrew/p5.rb
    brew upgrade https://raw.githubusercontent.com/hamstergene/p5/master/homebrew/p5.rb

If you are not using Homebrew or not on OS X, you can clone git repository and symlink `p5` where you need it - this is one-file utility. This script depends on `python3` package.

`p4` command line tool must be present and configured as necessary. If it's not, you need to add something like this to your `~/.profile`:

    export P4PORT=perforce.mycompany.com:1666
    export P4USER=MyUsername
    export P4CONFIG=.perforce

**The last line `export P4CONFIG=.perforce` is the most essential**. For some reason, `p4` assumes no default value for it.

Restart terminal or relogin, and create `.perforce` files in root of each workspace with the following line:

    P4CLIENT=current-workspace-name

    # optional
    # P5CLIENTSPEC=//depot/path/to/client_view_definition.txt
    # P5CLIENTSPEC=/path/to/client_view_definition.txt

Then do `p4 login` and check whether workspace name has been detected correctly by running `p4 info` from the workspace folder.

## Ignoring files with `.p4ignore`

If the workspace root contains `.p4ignore` file, it will be used. The format is similar to `.gitignore`:

* One pattern per line.
* If pattern does not contain '/', it matches files anywhere in workspace tree.
* If pattern ends with '/', it matches directories anywhere in workspace tree.
* If pattern starts with '/', it will only match absolute paths rooted at workspace, e.g. `/tags` matches `tags` file in workspace root, but not elsewhere in the tree.
* `.p4ignore` file itself is not ignored by default. You should add it there youself when you are not going to keep it under version control.

## Misc

I also recommend using this in your `.profile` for improved `p4 diff`/`p5 diff` experience:

    export P4DIFF='git --no-pager diff --color'
    export PAGER='less -R'

