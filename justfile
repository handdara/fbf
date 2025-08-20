alias a := session
session_name := 'fbf'
jd := justfile_directory()
hd := env_var('HOME')
startup_cmd := 'nix develop'
bldr_name := 'fbf'

# build and run
default: _bootstrap build tags clean

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

build: format
    ./{{bldr_name}}

clean:
    rm *.o *.mod

format:
    @alejandra . > /dev/null 2>&1

_bootstrap:
    gfortran -std=f2018 fbf.f90 build.f90 -o {{bldr_name}}
