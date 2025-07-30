module depend
end module depend

program fortress
    use, intrinsic :: iso_fortran_env, only: stderr => error_unit
    implicit none

    integer, parameter :: LINELEN=80
    integer, parameter :: FNAMELEN=25
    integer, parameter :: MAXFILECOUNT=10
    integer :: rc
    character(len=*), parameter :: FORTEFILE='fortefile.nml'
    call readftf(rc)
    if (rc /= 0) stop rc
contains

    subroutine readftf (iostat)
        integer, intent(out) :: iostat
        character(len=LINELEN) :: name
        character(len=FNAMELEN), dimension(MAXFILECOUNT) :: dependencies
        integer :: nunit, idx
        namelist /mainfile/ name
        namelist /srcfiles/ dependencies

        dependencies = [("", idx=1,MAXFILECOUNT)]

        open (file=FORTEFILE, newunit=nunit, iostat=iostat)
        if (iostat /= 0) return

        read (nunit, nml=mainfile, end=1001)
        read (nunit, nml=srcfiles, end=1001)

        print *, 'main file name: ', name
        print *, 'deps: ', dependencies
        return

        1001 write (stderr, '("Error: reached end of file, ", a, " ... Are all namelists defined?")') FORTEFILE
        iostat = 1001
        return
    end subroutine readftf

end program fortress
