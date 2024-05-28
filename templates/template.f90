program progam_name
  implicit none

  ! a comment
  write (*,*) "hello, world!" ! another comment

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

end program progam_name
