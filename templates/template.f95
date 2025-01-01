program FILENAME-EXT
  use, intrinsic:: iso_c_binding
  implicit none

  ! a comment
  print *, "hello, world!" ! another comment

contains

  !------------------------------------------------------------------------------------------------------------------------------
  function func_name(a)
    implicit none
    real, intent(in) :: a
    real funcname
  end function func_name
  
  !------------------------------------------------------------------------------------------------------------------------------
  subroutine sub_name(a, b, c)
    implicit none
    real, intent(in)    :: a
    real, intent(out)   :: b
    real, intent(inout) :: c
  end subroutine sub_name

end program FILENAME-EXT
