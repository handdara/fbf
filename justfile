alias r := run
jd := justfile_directory()

default: _dev-build run

# drop into dev shell
develop:
    nix develop --command ghostty

tags:
    ctags -R

@run:
    ./bin/build_fortress
    #cat fortefile.nml

_dev-build: tags
    @alejandra . > /dev/null 2>&1
    gfortran -std=f2018 fortress.f90 -o bin/build_fortress
