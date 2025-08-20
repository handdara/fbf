program builder
    use fbf
    implicit none
    integer :: rc

    call compile_src('a.f90', rc)
    call compile_src('b.f90', rc)
end program builder 
