alias r := run
alias a := session
session_name := 'fbf'
jd := justfile_directory()
hd := env_var('HOME')
startup_cmd := 'nix develop'
bldr_name := 'build'

# build and run
default: _dev-build run tags

# start tmux session
session:
    #!/usr/bin/env bash
    set -exo pipefail
    if ! tmux has-session -t={{session_name}} 2> /dev/null; then
        tmux new-session -ds {{session_name}} -c {{jd}} {{startup_cmd}}
    fi
    if [ -z $TMUX ] ; then
        echo 'tmux a -t {{session_name}}' | xclip -rmlastnl -selection clipboard
        echo 'Run `tmux a -t {{session_name}}`. Which has been placed into the system clipboard.'
    else
        echo 'switching client'
        tmux switch-client -t {{session_name}}
    fi

@tags:
    ctags -R

@run:
    ./bin/{{bldr_name}}

_dev-build:
    @alejandra . > /dev/null 2>&1
    gfortran -std=f2018 fbf.f90 build.f90 -o bin/{{bldr_name}}
