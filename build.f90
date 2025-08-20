program builder
    use fbf
    implicit none
    integer :: rc

    !call set_log_level(LL_TRACE)

    call compile_src('a.f90', rc)
    call compile_src('b.f90', rc)
end program builder 
