module fbf_opt
    implicit none
    character(len=*), parameter :: prg_compiler = 'gfortran'
    character(len=*), parameter :: flag_compile = '-c'
    character(len=*), parameter :: flag_output = '-o'
    character(len=*), parameter :: flag_module = '-I'
    character(len=*), parameter :: flag_std = 'f2018'
end module fbf_opt

module fbf_log
    use, intrinsic :: iso_fortran_env, only: stderr => error_unit
    implicit none
    !LL := log level
    integer, parameter :: LL_ERROR = 1
    integer, parameter :: LL_WARN = 2
    integer, parameter :: LL_INFO = 3
    integer, parameter :: LL_DEBUG = 4
    integer, parameter :: LL_TRACE = 5
    integer :: log_level = LL_INFO
contains

    subroutine log (lvl,msg)
        integer, intent(in) :: lvl
        character(len=*), intent(in) :: msg
        select case (lvl)
        case (LL_ERROR)
            if (LL_ERROR <= log_level) write (stderr, '("[LOG::ERROR] ", a)') msg
        case (LL_WARN)
            if (LL_WARN <= log_level) write (stderr, '("[LOG::WARN] ", a)') msg
        case (LL_INFO)
            if (LL_INFO <= log_level) write (stderr, '("[LOG::INFO] ", a)') msg
        case (LL_DEBUG)
            if (LL_DEBUG <= log_level) write (stderr, '("[LOG::DEBUG] ", a)') msg
        case (LL_TRACE)
            if (LL_TRACE <= log_level) write (stderr, '("[LOG::TRACE] ", a)') msg
        case default
            if (lvl <= log_level) write (stderr, '("[LOG::] ", a)') msg
        end select
    end subroutine log

    subroutine logError(msg)
        character(len=*), intent(in) :: msg
        call log (LL_ERROR, msg)
    end

    subroutine logWarn(msg)
        character(len=*), intent(in) :: msg
        call log (LL_WARN, msg)
    end

    subroutine logInfo(msg)
        character(len=*), intent(in) :: msg
        call log (LL_INFO, msg)
    end

    subroutine logDebug(msg)
        character(len=*), intent(in) :: msg
        call log (LL_DEBUG, msg)
    end

    subroutine logTrace(msg)
        character(len=*), intent(in) :: msg
        call log (LL_TRACE, msg)
    end

    function get_log_level () result(res)
        integer :: res
        res = log_level
    end

end module fbf_log

module fbf
    use fbf_opt
    use fbf_log
    implicit none
    private

    character(len=:), allocatable :: srcfiles

    public :: logError, logWarn, logInfo, logDebug, logTrace
    public :: LL_ERROR, LL_WARN, LL_INFO, LL_DEBUG, LL_TRACE
    public :: get_log_level
    public :: compile_src
contains

    !call execute_command_line('gfortran a.o b.o -o b.out')

    subroutine record_src(srcfile)
        character(len=*), intent(in) :: srcfile
        if (.not. allocated(srcfiles)) then
            srcfiles = srcfile
        else
            srcfiles = srcfiles // new_line(srcfiles) // srcfile
        end if
        call logTrace('updated srcfiles: ' // srcfiles)
    end subroutine record_src

    subroutine compile_src (srcfile, rc)
        character(len=*), intent(in) :: srcfile
        character(len=*), parameter :: cmd_nosrc = prg_compiler &
            & // ' -std=' // flag_std // ' ' &
            & // ' ' // flag_compile // ' '
        integer, intent(out) :: rc !return condition
        character(len=:), allocatable :: cmd 
        character(len=:), allocatable :: errmsg
        cmd = cmd_nosrc // srcfile
        call logInfo('$ '//cmd)
        call record_src(srcfile)
        call execute_command_line(cmd, cmdstat=rc, cmdmsg=errmsg)
        if (rc /= 0) stop errmsg
    end subroutine compile_src

end module fbf
